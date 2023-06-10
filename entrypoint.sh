#!/bin/sh

# 啟動 Nginx
nginx -g "daemon off;" &

# 抓取 m3u8 串流並轉換為 HLS
ffmpeg -i "$HLS_URL" \
    -c:v copy -c:a copy -f hls -ignore_io_errors 1 -hls_playlist_type event /tmp/hls/output.m3u8

ffmpeg -i "/tmp/hls/output.m3u8" \
    -c:v copy -c:a copy /tmp/output.mp4

# 上傳至 Google Drive
./uploadGoogleDrive.sh

# 阻塞容器，以保持運行
# tail -f /dev/null
sleep 1m 
