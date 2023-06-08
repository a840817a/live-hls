#!/bin/sh

# 設定環境變數中的 Google 服務帳戶金鑰內容
# export SERVICE_ACCOUNT_KEY='YOUR_KEY'

# 設定上傳檔案的路徑和 Google Drive 目標資料夾的 ID 以及檔案名稱
FILE_PATH="/tmp/output.mp4"
# DRIVE_FOLDER_ID="YOUR_FOLDER_ID"
# FILE_NAME="UPLOAD_FILE_NAME"

# 檢查有沒有設定 SERVICE_ACCOUNT_KEY, DRIVE_FOLDER_ID, FILE_NAME
if [ -z "$SERVICE_ACCOUNT_KEY" ] || [ -z "$DRIVE_FOLDER_ID" ] || [ -z "$FILE_NAME" ]
then
  exit
fi

# 取得環境變數中的相關變數
CLIENT_ID=$(echo "$SERVICE_ACCOUNT_KEY" | jq -r '.client_id')
CLIENT_EMAIL=$(echo "$SERVICE_ACCOUNT_KEY" | jq -r '.client_email')
PRIVATE_KEY=$(echo "$SERVICE_ACCOUNT_KEY" | jq -r '.private_key')

# 產生 JWT 的標頭（header）
HEADER='{
  "alg": "RS256",
  "typ": "JWT"
}'

# 產生 JWT 的有效負載（payload）
PAYLOAD=$(cat <<EOF
{
  "iss": "$CLIENT_EMAIL",
  "scope": "https://www.googleapis.com/auth/drive",
  "aud": "https://www.googleapis.com/oauth2/v4/token",
  "exp": $(($(date +%s) + 3600)),
  "iat": $(date +%s)
}
EOF
)

# Base64 編碼標頭和有效負載
ENCODED_HEADER=$(echo -n "$HEADER" | base64 -w 0 | tr '+/' '-_' | tr -d '=')
ENCODED_PAYLOAD=$(echo -n "$PAYLOAD" | base64 -w 0 | tr '+/' '-_' | tr -d '=')

# 將標頭和有效負載組合成 JWT
JWT="$ENCODED_HEADER.$ENCODED_PAYLOAD"

# 使用金鑰進行簽署
SIGNATURE=$(echo -n "$JWT" | openssl dgst -binary -sha256 -sign <(echo -n "$PRIVATE_KEY") | base64 -w 0 | tr '+/' '-_' | tr -d '=')

# 將簽署結果加入 JWT
SIGNED_JWT="$JWT.$SIGNATURE"

# 取得存取權杖
ACCESS_TOKEN=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=$SIGNED_JWT" \
  "https://www.googleapis.com/oauth2/v4/token" | jq -r .access_token)

# 取得上傳 URL
UPLOAD_URL=$(curl -s -i -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"$FILE_NAME.mp4\",\"parents\": [\"$DRIVE_FOLDER_ID\"]}" \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable&supportsAllDrives=true" | \
  awk '/location/ {print $2}' | tr -d '\r')

# 上傳檔案
curl -X PUT \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/octet-stream" \
  -T "$FILE_PATH" \
  "$UPLOAD_URL"
