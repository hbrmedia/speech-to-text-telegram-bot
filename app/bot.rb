require 'telegram/bot'
require 'open-uri'
require_relative '../lib/yandex_speech_kit/recognition'

class BotController < Telegram::Bot::UpdatesController

  TEXT_WELCOME = "<b>Добро пожаловать!</b> \u{1F916}".freeze
  TEXT_INVITATION = "Отправьте голосове сообщение для конвертации в текст.".freeze
  TEXT_SERVICE_ERROR = "Ошибка, попробуйте снова.".freeze
  TEXT_RECOGNITION_ERROR = "Ошибка распознавания.".freeze

  def start!(*)
    text = "#{TEXT_WELCOME}\n#{TEXT_INVITATION}"

    respond_with :message, text:, parse_mode: 'HTML'
  end

  def message(message)
    voice = message['voice']
    return respond_with :message, text: TEXT_INVITATION unless voice

    file = get_file(voice['file_id'])
    return respond_with :message, text: TEXT_SERVICE_ERROR unless file

    text = recognize(file) || TEXT_RECOGNITION_ERROR
    respond_with :message, text:
  end

  private

  def get_file(file_id)
    file = Telegram.bot.get_file(file_id:).with_indifferent_access
    file => { ok:, result: }
    return unless ok

    uri = URI.parse("https://api.telegram.org/file/bot#{ENV['TELEGRAM_TOKEN']}/#{result['file_path']}")
    uri.open.read
  end

  def recognize(file)
    recognition = YandexSpeechKit::Recognition.new(
      iam_token: ENV['YANDEX_IAM_TOKEN'],
      folder_id: ENV['YANDEX_FOLDER_ID']
    )
    recognition.recognize(file) => { data:, errors: }
    return if errors || data.empty?
    data
  end
end