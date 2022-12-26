# frozen_string_literal: true

require 'faraday'

module Yandex
  class Client
    def initialize(url, type = :url_encoded, api_key = nil)
      @url = url
      @type = type
      @api_key = api_key || Yandex.config[:api_key]
      @faraday_client = faraday_client
    end

    def get(url: '')
      response = @faraday_client.get(url)
      Response.new(response)
    end

    def post(url: '', payload: nil)
      response = @faraday_client.post(url, payload)
      Response.new(response)
    end

    private

    def faraday_client
      headers = {
        'Accept' => 'application/json',
        'Authorization' => "Api-Key #{@api_key}"
      }

      Faraday.new(url: @url, headers:) do |f|
        f.request @type
        f.response :json, parser_options: { object_class: OpenStruct }
      end
    end
  end
end