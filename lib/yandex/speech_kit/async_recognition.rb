# frozen_string_literal: true

module Yandex
  module SpeechKit
    class AsyncRecognition
      BASE_URL = 'https://transcribe.api.cloud.yandex.net/speech/stt/v2/longRunningRecognize'

      def initialize
        @client = Client.new(BASE_URL, :json)
      end

      def recognize(file_uri)
        payload = {
          "config": {
            "specification": {
              "languageCode": "ru-RU"
            }
          },
          "audio": {
            "uri": file_uri
          }
        }

        @client.post(payload:) => { data:, errors: }
        Operation.new(data) unless errors
      end
    end
  end
end