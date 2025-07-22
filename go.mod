module epusdt_new

go 1.24.4

require (
    github.com/ethereum/go-ethereum v1.15.6
    github.com/fbsobreira/gotron-sdk v0.24.0
    github.com/gin-gonic/gin v1.10.1
    github.com/go-telegram-bot-api/telegram-bot-api/v5 v5.5.1
    github.com/joho/godotenv v1.5.1
    github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e
    gorm.io/driver/mysql v1.6.0
    gorm.io/gorm v1.30.0
)

require (
    filippo.io/edwards25519 v1.1.0 // indirect
    github.com/go-sql-driver/mysql v1.8.1 // indirect
    github.com/jinzhu/inflection v1.0.0 // indirect
    github.com/jinzhu/now v1.1.5 // indirect
    golang.org/x/text v0.23.0 // indirect
)

replace github.com/fbsobreira/gotron-sdk => github.com/minho-dev/gotron-sdk v0.24.0