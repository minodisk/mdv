zip dist.zip dist
curl \
  -H "Authorization: Bearer $TOKEN"  \
  -H "x-goog-api-version: 2" \
  -X PUT \
  -T dist.zip \
  -v \
  https://www.googleapis.com/upload/chromewebstore/v1.1/items/$APP_ID
