
lib_dir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'telegram/bot'
require 'redis'
require 'json'
require 'yandex'

Redis.current = Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })

Telegram.bots_config[:default] = ENV['TELEGRAM_TOKEN']

Yandex.config = {
  access_key_id: ENV['YANDEX_ACCESS_KEY_ID'],
  access_key: ENV['YANDEX_ACCESS_KEY'],
  api_key_id: ENV['YANDEX_API_KEY_ID'],
  api_key: ENV['YANDEX_API_KEY'],
  s3: {
    region: 'ru-central1',
    endpoint: 'https://storage.yandexcloud.net',
    bucket: 'ambucket'
  }
}
