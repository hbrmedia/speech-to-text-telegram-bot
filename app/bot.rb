# frozen_string_literal: true

require 'open-uri'
require_relative '../config/app'

class BotController < Telegram::Bot::UpdatesController

  TEXT_WELCOME = "<b>Добро пожаловать!</b> \u{1F916}"
  TEXT_INVITATION = "Отправьте голосове сообщение для конвертации в текст."
  TEXT_ASYNC_PROCESSING = "Распознавание..."
  TEXT_FILE_ERROR = "Неверный формат аудио-файла. Максимальный размер: 1Гб, длительность: 4 часа."
  TEXT_SERVICE_ERROR = "Ошибка, попробуйте снова."
  TEXT_RECOGNITION_ERROR = "Ошибка распознавания."

  SYNC_MAX_DURATION = 30.freeze
  SYNC_MAX_SIZE = 1.megabyte.freeze
  ASYNC_MAX_DURATION = (4 * 3600).freeze
  ASYNC_MAX_SIZE = 1.gigabyte.freeze

  def start!(*)
    text = "#{TEXT_WELCOME}\n#{TEXT_INVITATION}"

    respond_with :message, text:, parse_mode: 'HTML'
  end

  def message(message)
    voice = (message['voice'] || message['audio'])&.with_indifferent_access

    text = voice ? recognize(voice) : TEXT_INVITATION
    respond_with :message, text:
  end

  private

  def recognize(voice)
    _recognition_method = recognition_method(voice)
    return TEXT_FILE_ERROR unless _recognition_method

    file = get_file(voice[:file_id])
    return TEXT_SERVICE_ERROR unless file

    voice[:file] = file
    send(_recognition_method, voice)
  end

  def recognition_method(voice)
    return :sync_recognize if voice[:duration] < SYNC_MAX_DURATION && voice[:file_size] < SYNC_MAX_SIZE
    :async_recognize if voice[:duration] < ASYNC_MAX_DURATION && voice[:file_size] < ASYNC_MAX_SIZE
  end

  def get_file(file_id)
    file = Telegram.bot.get_file(file_id:).with_indifferent_access
    file => { ok:, result: }
    return unless ok

    uri = URI.parse("https://api.telegram.org/file/bot#{ENV['TELEGRAM_TOKEN']}/#{result['file_path']}")
    uri.open.read
  end

  def sync_recognize(voice)
    recognition = Yandex::SpeechKit::Recognition.new
    recognition.recognize(voice[:file]) => { data:, errors: }
    result = data&.result
    return TEXT_RECOGNITION_ERROR if errors || result&.empty?
    result
  end

  def async_recognize(voice)
    voice => { file:, file_unique_id: filename }
    file_uri = Yandex::ObjectStorage.new.put(file, filename)
    operation = Yandex::SpeechKit::AsyncRecognition.new.recognize(file_uri)
    return TEXT_RECOGNITION_ERROR unless operation

    Redis.current.set("stt.operations.#{operation.id}", [from['id'], operation.to_h].to_json)
    TEXT_ASYNC_PROCESSING
  end
end