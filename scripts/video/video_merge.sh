#!/usr/bin/env bash
# 批量裁剪视频文件夹中的片头/片尾：
# - 第一个视频：保留片头，删除片尾
# - 最后一个视频：删除片头，保留片尾
# - 中间视频：片头和片尾都删除
# - 仅一个视频时：不做裁剪，直接复制
#
# 默认使用 ffmpeg 流复制（-c copy）无损批处理。
# 注意：无损裁切只能落在关键帧附近；需要帧级精确时加 -r。
#
# 依赖：ffmpeg、ffprobe
#
# 用法：
#   /Users/shang/GitHub/trim_video.sh <视频文件夹> [-s <片头秒数>] [-e <片尾秒数>] [-r]
#
# 示例：
#   /Users/shang/GitHub/trim_video.sh ~/Movies/episode -s 5 -e 8
#   裁剪输出: ~/Movies/episode/trimmed/
#   合并输出: ~/Movies/episode/trimmed/<首个视频序号前前缀>.mp4

set -euo pipefail

INPUT_DIR=""
OUTPUT_SUBDIR="trimmed"
INTRO_SECONDS="5"
OUTRO_SECONDS="5"
# 默认无损流复制；-r 时改为重编码（更精确但有损）
REENCODE=0

print_usage() {
  cat <<'EOF'
用法:
  trim_video.sh <视频文件夹> [-s <片头秒数>] [-e <片尾秒数>] [-r]

参数:
  <视频文件夹>  待处理视频所在目录（必填）
  -s            片头时长，单位秒（默认: 5）
  -e            片尾时长，单位秒（默认: 5）
  -r            重编码模式（帧级更准，但有损且更慢；默认关闭，使用无损 -c copy）
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
  默认 -c copy 无损批处理；切点依赖关键帧，可能与设定秒数略有偏差。
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

format_seconds() {
  awk -v value="$1" 'BEGIN { printf "%.3f", value + 0 }'
}

# 无损裁切：流复制，不重新编码
trim_video_copy() {
  local input_path="$1"
  local output_path="$2"
  local start_seconds="$3"
  local keep_duration="$4"
  ffmpeg -y -hide_banner -loglevel error \
    -ss "$start_seconds" \
    -i "$input_path" \
    -t "$keep_duration" \
    -c copy \
    -avoid_negative_ts make_zero \
    -movflags +faststart \
    "$output_path"
}

# 重编码裁切：更精确，但有损
trim_video_reencode() {
  local input_path="$1"
  local output_path="$2"
  local start_seconds="$3"
  local end_seconds="$4"
  ffmpeg -y -hide_banner -loglevel error \
    -i "$input_path" \
    -ss "$start_seconds" \
    -to "$end_seconds" \
    -c:v libx264 -preset veryfast -crf 18 \
    -c:a aac -b:a 192k \
    -movflags +faststart \
    "$output_path"
}

copy_video() {
  local input_path="$1"
  local output_path="$2"
  ffmpeg -y -hide_banner -loglevel error \
    -i "$input_path" \
    -c copy \
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

# 按自然排序后无损合并
merge_trimmed_videos() {
  local merge_output="$1"
  shift
  local files=("$@")
  local file_count="${#files[@]}"
  [[ "$file_count" -gt 0 ]] || die "没有可合并的裁剪视频"
  if [[ "$file_count" -eq 1 ]]; then
    echo "仅 1 个裁剪视频，直接复制为合并结果"
    copy_video "${files[0]}" "$merge_output"
    return
  fi
  local list_file
  list_file="$(mktemp -t trim_video_concat.XXXXXX)"
  local file_path=""
  for file_path in "${files[@]}"; do
    escape_concat_path "$file_path" >> "$list_file"
  done
  echo "开始合并 ${file_count} 个视频（自然排序，无损 -c copy）..."
  local index=0
  for file_path in "${files[@]}"; do
    index=$((index + 1))
    echo "  [$index/$file_count] $(basename "$file_path")"
  done
  if ffmpeg -y -hide_banner -loglevel error \
    -f concat -safe 0 \
    -i "$list_file" \
    -c copy \
    -movflags +faststart \
    "$merge_output"; then
    rm -f "$list_file"
    return
  fi
  echo "无损合并失败，改用重编码合并..."
  if ffmpeg -y -hide_banner -loglevel error \
    -f concat -safe 0 \
    -i "$list_file" \
    -c:v libx264 -preset veryfast -crf 18 \
    -c:a aac -b:a 192k \
    -movflags +faststart \
    "$merge_output"; then
    rm -f "$list_file"
    return
  fi
  rm -f "$list_file"
  die "视频合并失败"
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

encode_mode="无损流复制 (-c copy)"
[[ "$REENCODE" -eq 1 ]] && encode_mode="重编码 (有损，更精确)"

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
