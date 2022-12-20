require 'faraday'

module YandexSpeechKit
  class Recognition
    attr_reader :iam_token, :folder_id, :client

    BASE_URL = 'https://stt.api.cloud.yandex.net/speech/v1/stt:recognize'.freeze

    def initialize(iam_token:, folder_id:)
      @iam_token = iam_token
      @folder_id = folder_id
      @client = get_client
    end

    def recognize(file)
      response = client.post(get_url, file)
      { data: response.body.result, errors: errors(response) }
    end

    private

    def get_url
      "?folderId=#{folder_id}"
    end

    def get_client
      headers = {
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{iam_token}"
      }

      Faraday.new(url: BASE_URL, headers:) do |f|
        f.request :url_encoded
        f.response :json, parser_options: { object_class: OpenStruct }
      end
    end

    def errors(response)
      ["#{response.status} #{response.reason_phrase}", response.body] unless response.success?
    end
  end
end
