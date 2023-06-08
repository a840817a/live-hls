#!/bin/sh

# 啟動 Nginx
nginx -g "daemon off;" &

# 抓取 m3u8 串流並轉換為 HLS
ffmpeg -i "$HLS_URL" \
    -c:v copy -c:a copy -f hls -hls_time 6 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/output.m3u8 \
    -c:v copy -c:a copy /tmp/output.mp4

# 上傳至 Google Drive
./uploadGoogleDrive.sh

# 阻塞容器，以保持運行
# tail -f /dev/null
sleep 30s 
