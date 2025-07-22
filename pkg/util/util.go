package util

import (
	"math/rand"
	"time"
)

const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func init() {
	rand.Seed(time.Now().UnixNano()) // 매 실행 시 다른 랜덤 결과 나오게 초기화
}

func RandString(n int) string {
	b := make([]byte, n) // n길이의 byte 슬라이스 생성
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))] // 무작위 문자 할당
	}
	return string(b) // 문자열로 변환 후 반환
}