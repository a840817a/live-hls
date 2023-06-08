FROM alpine:latest

# 安裝必要的套件
RUN apk add --no-cache ffmpeg nginx curl jq openssl

# 建立目錄用於儲存輸出的 HLS 檔案
RUN mkdir /tmp/hls && chown nginx:nginx /tmp/hls

# 複製 Nginx 配置檔
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /tmp/hls/index.html

# 指定工作目錄
WORKDIR /home/

# 複製腳本到容器中
COPY entrypoint.sh uploadGoogleDrive.sh /home/

# 修改腳本權限
RUN chmod a+x entrypoint.sh uploadGoogleDrive.sh

# 切換使用者到 nginx
USER nginx

# 暴露 Nginx 監聽端口
EXPOSE 8080

# 指定 entrypoint 腳本
ENTRYPOINT ["/home/entrypoint.sh"]
