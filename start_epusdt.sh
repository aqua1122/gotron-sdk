#!/bin/bash
cd /home/minho/epusdt_new

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
export $(cat .env | grep -v '^#' | xargs)   # .env의 모든 변수 환경에 export (중요)
# ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

LOG_FILE=run.log

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ===== STARTING =====" >> $LOG_FILE

# 0. 실행파일 체크
if [ ! -f ./ngrok ]; then
    echo "ngrok 실행파일이 없습니다!" >> $LOG_FILE
    exit 1
fi
if [ ! -f ./epusdt_new ]; then
    echo "epusdt_new 실행파일이 없습니다!" >> $LOG_FILE
    exit 1
fi
if [ ! -f .env ]; then
    echo ".env 파일이 없습니다. 복사 또는 신규생성 필요!" >> $LOG_FILE
    exit 1
fi

# 1. 기존 ngrok, epusdt_new 강제 종료 (중복방지)
killall ngrok 2>/dev/null
killall epusdt_new 2>/dev/null
sleep 1

# 2. ngrok 자동 실행 (9020 포트 → https 터널 오픈)
nohup ./ngrok http 9020 > ngrok.log 2>&1 &

# 3. ngrok URL 파싱 (최대 10초 대기, 1초마다 시도)
for i in {1..10}; do
    sleep 1
    NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -oE 'https://[a-zA-Z0-9.-]+\.ngrok-free\.app')
    if [ ! -z "$NGROK_URL" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] NGROK_URL = $NGROK_URL" >> $LOG_FILE
        break
    fi
done

# 4. .env 파일 내 WEBHOOK_URL 자동 업데이트
if [ ! -z "$NGROK_URL" ]; then
    sed -i "s#^WEBHOOK_URL=.*#WEBHOOK_URL=${NGROK_URL}/webhook#g" .env
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] .env WEBHOOK_URL 갱신완료" >> $LOG_FILE
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ngrok URL을 찾을 수 없음. 10초 이상 대기실패." >> $LOG_FILE
fi

# 5. 봇 실행
nohup ./epusdt_new >> $LOG_FILE 2>&1 &
echo "[$(date '+%Y-%m-%d %H:%M:%S')] epusdt_new 봇 실행완료" >> $LOG_FILE

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ===== ALL READY =====" >> $LOG_FILE
exit 0
