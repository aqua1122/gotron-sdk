#!/bin/bash

# AQUABOT 봇 24시간 자동 재실행 스크립트
# 오류 발생 시 자동으로 재시작

echo "🤖 AQUABOT 봇 24시간 자동 재실행 시작..."
echo "⏰ 시작 시간: $(date)"
echo "🔄 오류 발생 시 자동 재시작됩니다."
echo ""

# 환경변수 로드 (개선된 방식)
if [ -f .env ]; then
    echo "📄 환경변수 파일 로드 중..."
    # 주석과 빈 줄 제거 후 환경변수 설정
    grep -v '^#' .env | grep -v '^$' | while read line; do
        export "$line"
    done
    echo "✅ 환경변수 로드 완료"
else
    echo "❌ .env 파일을 찾을 수 없습니다."
    echo "📝 기본 환경변수 설정 중..."
    export TELEGRAM_BOT_TOKEN="8083879103:AAFar4A5KwBvtMg2r3EJTs5MuZafFNVHOBA"
    export DB_HOST="localhost"
    export DB_PORT="3306"
    export DB_USER="root"
    export DB_PASSWORD="123456"
    export DB_NAME="aquabot"
    echo "✅ 기본 환경변수 설정 완료"
fi

# 기존 프로세스 종료
echo "🔄 기존 봇 프로세스 종료 중..."
pkill -f aquabot
sleep 2

# 포트 확인 및 해제
echo "🔍 포트 9020 확인 중..."
if lsof -ti:9020 > /dev/null 2>&1; then
    echo "⚠️ 포트 9020이 사용 중입니다. 해제 중..."
    lsof -ti:9020 | xargs kill -9
    sleep 1
fi

# 봇 실행 카운터
restart_count=0
max_restarts=100

while [ $restart_count -lt $max_restarts ]; do
    restart_count=$((restart_count + 1))
    echo ""
    echo "🚀 봇 시작 시도 #$restart_count ($(date))"
    
    # 봇 실행
    ./aquabot &
    bot_pid=$!
    
    echo "📊 봇 프로세스 ID: $bot_pid"
    
    # 봇 상태 모니터링
    sleep 10
    
    # 봇이 살아있는지 확인
    if ! kill -0 $bot_pid 2>/dev/null; then
        echo "❌ 봇이 종료되었습니다. 재시작 중..."
        sleep 2
        continue
    fi
    
    echo "✅ 봇이 정상 실행 중입니다."
    
    # 봇이 계속 실행되는 동안 대기
    while kill -0 $bot_pid 2>/dev/null; do
        sleep 30
        
        # 메모리 사용량 확인
        if command -v ps >/dev/null 2>&1; then
            mem_usage=$(ps -o rss= -p $bot_pid 2>/dev/null | awk '{print $1/1024}')
            if [ ! -z "$mem_usage" ] && [ $(echo "$mem_usage > 500" | bc -l 2>/dev/null || echo "0") -eq 1 ]; then
                echo "⚠️ 메모리 사용량이 높습니다: ${mem_usage}MB"
            fi
        fi
    done
    
    echo "❌ 봇이 예기치 않게 종료되었습니다. 재시작 중..."
    sleep 3
done

echo "❌ 최대 재시작 횟수에 도달했습니다. 스크립트를 종료합니다." 