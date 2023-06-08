# 直播 HLS 專案

這是一個用於重新直播 HLS（HTTP Live Streaming）的專案。它使用 Docker 容器化應用程序來抓取 m3u8 串流並轉換為 HLS 格式，然後將輸出上傳到 Google Drive。

## 系統要求

- Docker

## 使用方法

1. 克隆專案到本地：

   ```
   git clone https://github.com/a840817a/live-hls.git
   ```

2. 進入專案目錄：

   ```
   cd repository
   ```

3. 建立 Docker 映像檔：

   ```
   docker build -t live-hls .
   ```

4. 執行 Docker 容器：

   ```
   docker run -p 8080:8080 -e HLS_URL="YOUR_HLS_URL" -e SERVICE_ACCOUNT_KEY="YOUR_SERVICE_ACCOUNT_KEY" -e DRIVE_FOLDER_ID="YOUR_DRIVE_FOLDER_ID" -e FILE_NAME="YOUR_FILE_NAME" live-hls
   ```

   請將以下值替換為您自己的設定：

   - `YOUR_HLS_URL`：輸入要抓取的 HLS 串流的 URL。
   - `YOUR_SERVICE_ACCOUNT_KEY`：Google 服務帳戶金鑰的內容。
   - `YOUR_DRIVE_FOLDER_ID`：Google Drive 目標資料夾的 ID。
   - `YOUR_FILE_NAME`：上傳到 Google Drive 的檔案名稱。

5. 在瀏覽器中訪問 `http://localhost:8080`，您應該能夠看到播放器並播放 HLS 直播串流。

## 程式碼結構

- `Dockerfile`：Docker 映像檔的建構腳本，包含了所需的套件和設定。
- `entrypoint.sh`：Docker 容器的入口點腳本，負責啟動 Nginx、抓取並轉換 HLS 串流、上傳到 Google Drive。
- `nginx.conf`：Nginx 的配置檔，設定了伺服器監聽端口和路徑映射。
- `index.html`：網頁播放器的 HTML 文件，使用 video.js 播放 HLS 串流。
- `uploadGoogleDrive.sh`：上傳檔案到 Google Drive 的腳本，使用 Google Drive API 和服務帳戶金鑰進行驗證和上傳。

## 注意事項

- 請確保您已經替換了相關的設定值，包括 HLS_URL、SERVICE_ACCOUNT_KEY、DRIVE_FOLDER_ID 和 FILE_NAME。
- 請確保您的 Google 服務帳戶金鑰具有適當的權限以進行 Google Drive 的上傳

操作。
- 請確保您的主機上的 8080 端口沒有被佔用。

## 其他資源

- [HTTP Live Streaming (HLS) 官方文件](https://developer.apple.com/streaming/)
- [Docker 官方網站](https://www.docker.com/)

如有任何疑問或問題，請隨時聯繫我們。