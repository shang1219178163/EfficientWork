#!/usr/bin/env bash
# 批量裁剪视频文件夹中的片头/片尾：
# - 第一个视频：保留片头，删除片尾
# - 最后一个视频：删除片头，保留片尾
# - 中间视频：片头和片尾都删除
# - 仅一个视频时：不做裁剪，直接复制
#
# 裁剪默认使用 ffmpeg 流复制（-c copy）加快批处理。
# 多段合并用 filter_complex concat 重编码拼接（禁止 AAC -c copy，避免后半段无声）。
# 需要帧级精确裁切时加 -r。
#
# 依赖：ffmpeg、ffprobe
#
# 用法：
#   video_merge.sh <视频文件夹> [-s <片头秒数>] [-e <片尾秒数>] [-r]
#
# 示例：
#   video_merge.sh ~/Movies/episode -s 5 -e 8
#   裁剪输出: ~/Movies/episode/trimmed/
#   合并输出: ~/Movies/episode/trimmed/<首个视频序号前前缀>.mp4

set -euo pipefail

INPUT_DIR=""
OUTPUT_SUBDIR="trimmed"
INTRO_SECONDS="5"
OUTRO_SECONDS="5"
# 默认无损流复制裁切；-r 时改为重编码（更精确但有损）
REENCODE=0

print_usage() {
  cat <<'EOF'
用法:
  video_merge.sh <视频文件夹> [-s <片头秒数>] [-e <片尾秒数>] [-r]

参数:
  <视频文件夹>  待处理视频所在目录（必填）
  -s            片头时长，单位秒（默认: 5）
  -e            片尾时长，单位秒（默认: 5）
  -r            重编码裁切（帧级更准，但有损且更慢；默认关闭，裁切用 -c copy）
  -h            显示帮助

输出:
  裁剪结果写入 <视频文件夹>/trimmed/
  裁剪完成后按文件名自然排序合并；合并文件名取第一个视频「序号之前」的部分
  例如: 剧名01.mp4 / 名【第01話】xxx.mp4 -> 取「【」或数字之前的部分

规则:
  1. 第一个视频：保留片头，删除片尾
  2. 最后一个视频：删除片头，保留片尾
  3. 中间视频：删除片头和片尾
  4. 仅一个视频：不裁剪，直接复制
  5. 全部裁剪完成后，按自然排序合并为一个视频

说明:
  裁切默认 -c copy（切点依赖关键帧，可能与设定秒数略有偏差）。
  多段合并始终重编码并统一音轨，降低丢音与衔接闪屏概率。
EOF
}

die() {
  echo "错误: $*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "未找到命令 '$1'，请先安装（macOS: brew install ffmpeg）"
}

is_number() {
  [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
}

get_video_duration() {
  local file_path="$1"
  ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file_path"
}

# 是否存在音频流
has_audio_stream() {
  local file_path="$1"
  local count
  count="$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$file_path" | wc -l | tr -d ' ')"
  [[ "${count:-0}" -gt 0 ]]
}

# 是否存在视频流（-ss 在 -i 后 + copy 可能只剩音轨）
has_video_stream() {
  local file_path="$1"
  local count
  count="$(ffprobe -v error -select_streams v -show_entries stream=index -of csv=p=0 "$file_path" | wc -l | tr -d ' ')"
  [[ "${count:-0}" -gt 0 ]]
}

format_seconds() {
  awk -v value="$1" 'BEGIN { printf "%.3f", value + 0 }'
}

# 无损裁切：-ss 必须在 -i 之前，否则 copy 可能丢掉视频流只剩音频
trim_video_copy() {
  local input_path="$1"
  local output_path="$2"
  local start_seconds="$3"
  local keep_duration="$4"
  ffmpeg -y -hide_banner -loglevel error \
    -ss "$start_seconds" \
    -i "$input_path" \
    -t "$keep_duration" \
    -map 0:v:0 \
    -map 0:a:0? \
    -c copy \
    -avoid_negative_ts make_zero \
    -movflags +faststart \
    "$output_path"
  if ! has_video_stream "$output_path"; then
    die "裁切后缺少视频流: $output_path（请改用 -r 重编码裁切）"
  fi
}

# 重编码裁切：更精确；统一像素格式与 AAC，缺音轨时补静音
trim_video_reencode() {
  local input_path="$1"
  local output_path="$2"
  local start_seconds="$3"
  local end_seconds="$4"
  if has_audio_stream "$input_path"; then
    # 重编码时 -ss 放在 -i 之后，按绝对时间精确裁切
    ffmpeg -y -hide_banner -loglevel error \
      -i "$input_path" \
      -ss "$start_seconds" \
      -to "$end_seconds" \
      -map 0:v:0 \
      -map 0:a:0 \
      -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p \
      -c:a aac -b:a 192k -ar 48000 -ac 2 \
      -af "aresample=async=1:first_pts=0" \
      -movflags +faststart \
      "$output_path"
    return
  fi
  echo "  提示: 源文件无音轨，补齐静音轨"
  local keep_duration
  keep_duration="$(awk -v s="$start_seconds" -v e="$end_seconds" 'BEGIN { printf "%.3f", e - s }')"
  ffmpeg -y -hide_banner -loglevel error \
    -i "$input_path" \
    -ss "$start_seconds" \
    -t "$keep_duration" \
    -f lavfi -i "anullsrc=channel_layout=stereo:sample_rate=48000" \
    -map 0:v:0 \
    -map 1:a:0 \
    -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -shortest \
    -movflags +faststart \
    "$output_path"
}

copy_video() {
  local input_path="$1"
  local output_path="$2"
  if has_audio_stream "$input_path"; then
    ffmpeg -y -hide_banner -loglevel error \
      -i "$input_path" \
      -map 0:v:0 \
      -map 0:a:0 \
      -c copy \
      -movflags +faststart \
      "$output_path"
    return
  fi
  echo "提示: 源文件无音轨，补齐静音轨后输出"
  ffmpeg -y -hide_banner -loglevel error \
    -i "$input_path" \
    -f lavfi -i "anullsrc=channel_layout=stereo:sample_rate=48000" \
    -map 0:v:0 \
    -map 1:a:0 \
    -c:v copy \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -shortest \
    -movflags +faststart \
    "$output_path"
}

# 合并前统一音轨为 AAC 48k 立体声（视频能 copy 则 copy，减少重复压缩）
normalize_segment_for_merge() {
  local input_path="$1"
  local output_path="$2"
  if ! has_video_stream "$input_path"; then
    die "合并前片段缺少视频流: $input_path"
  fi
  if has_audio_stream "$input_path"; then
    if ffmpeg -y -hide_banner -loglevel error \
      -i "$input_path" \
      -map 0:v:0 \
      -map 0:a:0 \
      -c:v copy \
      -c:a aac -b:a 192k -ar 48000 -ac 2 \
      -af "aresample=async=1:first_pts=0" \
      -movflags +faststart \
      "$output_path"; then
      return
    fi
    echo "  提示: 视频流复制失败，改用重编码规范化"
    ffmpeg -y -hide_banner -loglevel error \
      -i "$input_path" \
      -map 0:v:0 \
      -map 0:a:0 \
      -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p \
      -c:a aac -b:a 192k -ar 48000 -ac 2 \
      -af "aresample=async=1:first_pts=0" \
      -movflags +faststart \
      "$output_path"
    return
  fi
  echo "  提示: $(basename "$input_path") 无音轨，补齐静音"
  ffmpeg -y -hide_banner -loglevel error \
    -i "$input_path" \
    -f lavfi -i "anullsrc=channel_layout=stereo:sample_rate=48000" \
    -map 0:v:0 \
    -map 1:a:0 \
    -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -shortest \
    -movflags +faststart \
    "$output_path"
}

# concat 列表中的路径转义（处理单引号）
escape_concat_path() {
  local path="$1"
  path="${path//\'/\'\\\'\'}"
  printf "file '%s'\n" "$path"
}

# 取文件名中「【」或数字之前」的部分，作为合并文件名
# 例:
#   剧名01.mp4 -> 剧名
#   デキちゃうまで婚【第01話】 [中文字幕].mp4 -> デキちゃうまで婚
extract_name_before_index() {
  local file_name
  file_name="$(basename "$1")"
  local base="${file_name%.*}"
  base="${base%_trimmed}"
  base="$(printf '%s' "$base" | sed -E \
    -e 's/【.*$//' \
    -e 's/[0-9].*$//' \
    -e 's/[-_ .]+$//' \
    -e 's/[[:space:]]+$//')"
  if [[ -z "$base" ]]; then
    base="${file_name%.*}"
    base="${base%_trimmed}"
  fi
  [[ -n "$base" ]] || base="merged"
  printf '%s' "$base"
}

get_stream_duration() {
  local file_path="$1"
  local stream_selector="$2"
  ffprobe -v error -select_streams "$stream_selector" \
    -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$file_path" | head -1
}

# 校验输出确实有可播放音轨，且音轨时长不能明显短于视频（防止后半段无声）
assert_output_has_audible_track() {
  local file_path="$1"
  local require_real_audio="$2"
  has_video_stream "$file_path" || die "合并结果缺少视频流: $file_path"
  has_audio_stream "$file_path" || die "合并结果缺少音频流: $file_path"
  local video_duration audio_duration
  video_duration="$(get_stream_duration "$file_path" v:0)"
  audio_duration="$(get_stream_duration "$file_path" a:0)"
  if [[ -n "$video_duration" && -n "$audio_duration" ]]; then
    if awk -v a="$audio_duration" -v v="$video_duration" 'BEGIN { exit !(v > 1 && a < v * 0.95) }'; then
      die "合并结果音轨过短（音频 ${audio_duration}s / 视频 ${video_duration}s），后半段可能无声: $file_path"
    fi
  fi
  if [[ "$require_real_audio" -eq 1 ]]; then
    local mean_volume
    # 只抽样片头，避免长视频全量检测过慢
    mean_volume="$(ffmpeg -hide_banner -t 45 -i "$file_path" -af volumedetect -f null - 2>&1 \
      | awk -F': ' '/mean_volume/ { print $2; exit }' \
      | awk '{ print $1 }')"
    if [[ -z "$mean_volume" ]]; then
      die "无法检测合并结果音量: $file_path"
    fi
    # -91 dB 近似数字静音；源有音轨却接近静音则失败
    if awk -v v="$mean_volume" 'BEGIN { exit !(v <= -90) }'; then
      die "合并结果几乎无声（mean_volume=${mean_volume} dB）: $file_path"
    fi
  fi
}

# 用 filter_complex concat 重编码拼接，避免 AAC -c copy 导致后半段音轨丢失
merge_normalized_with_filter() {
  local merge_output="$1"
  shift
  local files=("$@")
  local file_count="${#files[@]}"
  local inputs=()
  local filter=""
  local index=0
  local file_path=""
  for file_path in "${files[@]}"; do
    inputs+=(-i "$file_path")
    filter+="[${index}:v:0][${index}:a:0]"
    index=$((index + 1))
  done
  filter+="concat=n=${file_count}:v=1:a=1[v][a]"
  ffmpeg -y -hide_banner -loglevel error \
    "${inputs[@]}" \
    -filter_complex "$filter" \
    -map "[v]" \
    -map "[a]" \
    -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -movflags +faststart \
    "$merge_output"
}

# 多段合并：先规范化音视频，再用 filter concat 重编码拼接
merge_trimmed_videos() {
  local merge_output="$1"
  shift
  local files=("$@")
  local file_count="${#files[@]}"
  [[ "$file_count" -gt 0 ]] || die "没有可合并的裁剪视频"
  local source_has_audio=0
  local file_path=""
  for file_path in "${files[@]}"; do
    if has_audio_stream "$file_path"; then
      source_has_audio=1
      break
    fi
  done
  if [[ "$file_count" -eq 1 ]]; then
    echo "仅 1 个裁剪视频，规范化后输出合并结果"
    normalize_segment_for_merge "${files[0]}" "$merge_output"
    assert_output_has_audible_track "$merge_output" "$source_has_audio"
    return
  fi
  local norm_dir
  norm_dir="$(mktemp -d -t trim_video_norm.XXXXXX)"
  local normalized_files=()
  local index=0
  echo "开始合并 ${file_count} 个视频（先统一编码，再 filter 拼接）..."
  for file_path in "${files[@]}"; do
    index=$((index + 1))
    local norm_path="${norm_dir}/seg_$(printf '%03d' "$index").mp4"
    echo "  [$index/$file_count] 规范化 $(basename "$file_path")"
    normalize_segment_for_merge "$file_path" "$norm_path"
    has_audio_stream "$norm_path" || die "规范化后仍无音轨: $norm_path"
    has_video_stream "$norm_path" || die "规范化后仍无视频流: $norm_path"
    normalized_files+=("$norm_path")
  done
  if ! merge_normalized_with_filter "$merge_output" "${normalized_files[@]}"; then
    rm -rf "$norm_dir"
    die "视频合并失败"
  fi
  rm -rf "$norm_dir"
  assert_output_has_audible_track "$merge_output" "$source_has_audio"
  echo "合并音画校验通过"
}

# 支持「文件夹在前」或「选项在前」两种写法
parse_args() {
  local positional=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s)
        [[ $# -ge 2 ]] || die "参数 -s 需要值"
        INTRO_SECONDS="$2"
        shift 2
        ;;
      -e)
        [[ $# -ge 2 ]] || die "参数 -e 需要值"
        OUTRO_SECONDS="$2"
        shift 2
        ;;
      -r)
        REENCODE=1
        shift
        ;;
      -h|--help)
        print_usage
        exit 0
        ;;
      -*)
        die "未知参数: $1"
        ;;
      *)
        positional+=("$1")
        shift
        ;;
    esac
  done
  [[ "${#positional[@]}" -ge 1 ]] || {
    print_usage
    die "必须指定视频文件夹"
  }
  [[ "${#positional[@]}" -eq 1 ]] || die "只能指定一个视频文件夹"
  INPUT_DIR="${positional[0]}"
}

parse_args "$@"

is_number "$INTRO_SECONDS" || die "片头时长必须是数字: $INTRO_SECONDS"
is_number "$OUTRO_SECONDS" || die "片尾时长必须是数字: $OUTRO_SECONDS"
[[ -d "$INPUT_DIR" ]] || die "视频文件夹不存在: $INPUT_DIR"

require_command ffmpeg
require_command ffprobe

INPUT_DIR="$(cd "$INPUT_DIR" && pwd)"
OUTPUT_DIR="${INPUT_DIR}/${OUTPUT_SUBDIR}"
mkdir -p "$OUTPUT_DIR"

video_files=()
while IFS= read -r -d '' file_path; do
  video_files+=("$file_path")
done < <(
  find "$INPUT_DIR" -maxdepth 1 -type f \
    \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.avi" \
       -o -iname "*.flv" -o -iname "*.wmv" -o -iname "*.m4v" -o -iname "*.webm" \
       -o -iname "*.ts" -o -iname "*.mpg" -o -iname "*.mpeg" \) \
    -print0 | sort -zV
)

total_count="${#video_files[@]}"
[[ "$total_count" -gt 0 ]] || die "视频文件夹中没有找到视频文件: $INPUT_DIR"

encode_mode="裁切无损流复制 (-c copy)，合并重编码"
[[ "$REENCODE" -eq 1 ]] && encode_mode="裁切与合并均重编码 (更精确)"

echo "视频目录: $INPUT_DIR"
echo "输出目录: $OUTPUT_DIR"
echo "片头时长: ${INTRO_SECONDS}s"
echo "片尾时长: ${OUTRO_SECONDS}s"
echo "编码模式: $encode_mode"
echo "视频数量: $total_count"
echo "----------------------------------------"

success_count=0
skip_count=0
trimmed_files=()

for index in "${!video_files[@]}"; do
  input_path="${video_files[$index]}"
  file_name="$(basename "$input_path")"
  file_ext="${file_name##*.}"
  # 无损保留原扩展名；重编码统一输出 mp4
  if [[ "$REENCODE" -eq 1 ]]; then
    output_path="${OUTPUT_DIR}/${file_name%.*}_trimmed.mp4"
  else
    output_path="${OUTPUT_DIR}/${file_name%.*}_trimmed.${file_ext}"
  fi
  duration_raw="$(get_video_duration "$input_path")"
  duration="$(format_seconds "$duration_raw")"
  position=$((index + 1))
  is_first=0
  is_last=0
  [[ "$index" -eq 0 ]] && is_first=1
  [[ "$index" -eq $((total_count - 1)) ]] && is_last=1
  start_seconds="0"
  end_seconds="$duration"
  action_desc=""
  if [[ "$total_count" -eq 1 ]]; then
    action_desc="仅一个视频，保留完整内容"
    echo "[$position/$total_count] $file_name"
    echo "  时长: ${duration}s | $action_desc"
    copy_video "$input_path" "$output_path"
    trimmed_files+=("$output_path")
    success_count=$((success_count + 1))
    echo "  完成 -> $output_path"
    continue
  fi
  if [[ "$is_first" -eq 1 ]]; then
    start_seconds="0"
    end_seconds="$(awk -v d="$duration" -v o="$OUTRO_SECONDS" 'BEGIN { printf "%.3f", d - o }')"
    action_desc="保留片头，删除片尾 ${OUTRO_SECONDS}s"
  elif [[ "$is_last" -eq 1 ]]; then
    start_seconds="$(format_seconds "$INTRO_SECONDS")"
    end_seconds="$duration"
    action_desc="删除片头 ${INTRO_SECONDS}s，保留片尾"
  else
    start_seconds="$(format_seconds "$INTRO_SECONDS")"
    end_seconds="$(awk -v d="$duration" -v o="$OUTRO_SECONDS" 'BEGIN { printf "%.3f", d - o }')"
    action_desc="删除片头 ${INTRO_SECONDS}s 与片尾 ${OUTRO_SECONDS}s"
  fi
  keep_duration="$(awk -v s="$start_seconds" -v e="$end_seconds" 'BEGIN { printf "%.3f", e - s }')"
  echo "[$position/$total_count] $file_name"
  echo "  时长: ${duration}s | $action_desc"
  if awk -v keep="$keep_duration" 'BEGIN { exit !(keep > 0.1) }'; then
    :
  else
    echo "  跳过: 裁剪后时长过短（${keep_duration}s），请检查片头/片尾参数"
    skip_count=$((skip_count + 1))
    continue
  fi
  echo "  保留区间: ${start_seconds}s -> ${end_seconds}s（约 ${keep_duration}s）"
  if [[ "$REENCODE" -eq 1 ]]; then
    trim_video_reencode "$input_path" "$output_path" "$start_seconds" "$end_seconds"
  elif ! has_audio_stream "$input_path"; then
    echo "  提示: 无音轨，改用重编码并补静音"
    output_path="${OUTPUT_DIR}/${file_name%.*}_trimmed.mp4"
    trim_video_reencode "$input_path" "$output_path" "$start_seconds" "$end_seconds"
  else
    trim_video_copy "$input_path" "$output_path" "$start_seconds" "$keep_duration"
  fi
  trimmed_files+=("$output_path")
  success_count=$((success_count + 1))
  echo "  完成 -> $output_path"
done

echo "----------------------------------------"
echo "裁剪完成: 成功 ${success_count}，跳过 ${skip_count}，总计 ${total_count}"
[[ "$success_count" -gt 0 ]] || die "没有成功裁剪的视频，无法合并"

# 按文件名自然排序后再合并
sorted_trimmed_files=()
while IFS= read -r -d '' file_path; do
  sorted_trimmed_files+=("$file_path")
done < <(printf '%s\0' "${trimmed_files[@]}" | sort -zV)

# 合并文件名：取自然排序后第一个原视频「序号之前」的部分
first_video_name="$(basename "${video_files[0]}")"
merge_base_name="$(extract_name_before_index "$first_video_name")"
MERGE_OUTPUT="${OUTPUT_DIR}/${merge_base_name}.mp4"
echo "合并文件名: ${merge_base_name}.mp4（来自首个视频: ${first_video_name}）"
merge_trimmed_videos "$MERGE_OUTPUT" "${sorted_trimmed_files[@]}"

echo "----------------------------------------"
echo "全部完成"
echo "裁剪目录: $OUTPUT_DIR"
echo "合并文件: $MERGE_OUTPUT"
