#!/bin/bash

ENV_FILE="/home/minho/epusdt_new/.env"
NGROK_API="http://127.0.0.1:4040/api/tunnels"

# ngrok API에서 https public URL 추출
NGROK_URL=$(curl -s $NGROK_API | grep -Po '"public_url":"https://[^"]+"' | head -1 | cut -d '"' -f4)

if [ -z "$NGROK_URL" ]; then
  echo "ngrok public URL을 찾을 수 없습니다."
  exit 1
fi

echo "현재 ngrok URL: $NGROK_URL"

# .env 파일 내 WEBHOOK_URL 갱신
if grep -q "^WEBHOOK_URL=" "$ENV_FILE"; then
  sed -i "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" "$ENV_FILE"
else
  echo "WEBHOOK_URL=$NGROK_URL" >> "$ENV_FILE"
fi

echo ".env 파일 갱신 완료."

# systemd 서비스 재시작
sudo systemctl daemon-reload
sudo systemctl restart epusdt_new
echo "epusdt_new 서비스 재시작 완료."
