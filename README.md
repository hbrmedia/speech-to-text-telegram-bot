# Speech to text Telegram bot

## Development (poller mode)
### Setup
Set environment variables in compose.yaml
```
TELEGRAM_TOKEN: TELEGRAM_TOKEN
YANDEX_ACCESS_KEY_ID: YANDEX_ACCESS_KEY_ID
YANDEX_ACCESS_KEY: YANDEX_ACCESS_KEY
YANDEX_API_KEY_ID: YANDEX_API_KEY_ID
YANDEX_API_KEY: YANDEX_API_KEY
```

Set Yandex S3 config in config/app.rb
```ruby
Yandex.config = {
  s3: {
    region: 'ru-central1',
    endpoint: 'https://storage.yandexcloud.net',
    bucket: 'bucket'
  }
}
```

### Run
```bash
docker compose up
```

## Production (webhook mode)

Use `bundle exec rackup` to run application in webhook mode