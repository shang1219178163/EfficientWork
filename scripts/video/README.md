# scripts

本目录存放常用本地脚本。依赖：`ffmpeg`、`ffprobe`（macOS 可用 `brew install ffmpeg`）。

## video_trim.sh

批量裁剪文件夹中视频的片头/片尾（**不合并**）。

规则：

1. 第一个视频：保留片头，删除片尾  
2. 最后一个视频：删除片头，保留片尾  
3. 中间视频：片头和片尾都删除  
4. 仅一个视频：不裁剪，直接复制  

默认无损（`-c copy`）；切点依赖关键帧，可能略有偏差。需要更精确时可加 `-r`（重编码，有损）。

### 用法

```bash
./video_trim.sh <视频文件夹> [-s <片头秒数>] [-e <片尾秒数>] [-r]
```

### 示例

```bash
# 片头 5 秒、片尾 8 秒（默认片头/片尾均为 5）
./video_trim.sh ~/Movies/episode -s 5 -e 8

# 重编码模式（切点更准，更慢）
./video_trim.sh ~/Movies/episode -s 3.5 -e 10 -r

# 查看帮助
./video_trim.sh -h
```

### 输出

裁剪结果写入：`<视频文件夹>/trimmed/`

---

## video_merge.sh

在 `video_trim.sh` 相同裁剪规则之上，裁剪完成后按文件名**自然排序**并**无损合并**为一个视频。

合并文件名取自然排序后第一个视频名称中「`【` 或数字之前」的部分。  
例如：`剧名01.mp4`、`xxxx【第01話】xxx.mp4` → `剧名.mp4` / `xx.mp4`。

### 用法

```bash
./video_merge.sh <视频文件夹> [-s <片头秒数>] [-e <片尾秒数>] [-r]
```

### 示例

```bash
# 裁剪并合并（片头 5 秒、片尾 8 秒）
./video_merge.sh ~/Movies/episode -s 5 -e 8

# 重编码裁剪后再合并
./video_merge.sh ~/Movies/episode -s 5 -e 8 -r

# 查看帮助
./video_merge.sh -h
```

### 输出

- 裁剪结果：`<视频文件夹>/trimmed/`
- 合并结果：`<视频文件夹>/trimmed/<片名>.mp4`
