require_relative "app/bot"

token = Telegram.bots_config[:default]
bot = Telegram::Bot::Client.new(token)

map "/#{token}" do
  run Telegram::Bot::Middleware.new(bot, BotController)
end