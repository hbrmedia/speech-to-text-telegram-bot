# frozen_string_literal: true

module Yandex
  module SpeechKit
    class Recognition
      BASE_URL = 'https://stt.api.cloud.yandex.net/speech/v1/stt:recognize'

      def initialize
        @client = Client.new(BASE_URL, :url_encoded)
      end

      def recognize(file)
        @client.post(payload: file)
      end
    end
  end
end