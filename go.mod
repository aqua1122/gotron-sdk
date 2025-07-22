module github.com/aqua1122/gotron-sdk

go 1.24

require (
	github.com/ethereum/go-ethereum v1.15.6
	github.com/gin-gonic/gin v1.10.1
	github.com/go-telegram-bot-api/telegram-bot-api/v5 v5.5.1
	github.com/joho/godotenv v1.5.1
	github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e
	gorm.io/driver/mysql v1.6.0
	gorm.io/gorm v1.30.0
)

replace github.com/fbsobreira/gotron-sdk => github.com/aqua1122/gotron-sdk v0.24.0