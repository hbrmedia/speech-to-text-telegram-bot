require_relative "app/bot"

token = ENV['TELEGRAM_TOKEN']
Telegram.bots_config[:default] = token
bot = Telegram::Bot::Client.new(token)

map "/#{token}" do
  run Telegram::Bot::Middleware.new(bot, BotController)
end