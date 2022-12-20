# Speech to text Telegram bot

## Development (poller mode)
### Setup
Set environment variables in compose.yaml
```
TELEGRAM_TOKEN: TELEGRAM_TOKEN
YANDEX_IAM_TOKEN: YANDEX_IAM_TOKEN
YANDEX_FOLDER_ID: YANDEX_FOLDER_ID
```

### Run

```bash
docker compose up
```

## Production (webhook mode)

Use `bundle exec rackup` to run application in webhook mode