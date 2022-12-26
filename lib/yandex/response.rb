# frozen_string_literal: true

module Yandex
  class Response
    attr_reader :data, :errors

    def initialize(response)
      @errors = parse_errors(response)
      @data = @errors ? nil : response.body
    end

    def deconstruct_keys(*)
      to_h
    end

    def to_h
      { data: @data, errors: @errors }
    end

    private

    def parse_errors(response)
      ["#{response.status} #{response.reason_phrase}", response.body] unless response.success?
    end
  end
end