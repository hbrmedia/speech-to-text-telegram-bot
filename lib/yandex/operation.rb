# frozen_string_literal: true

module Yandex
  class Operation
    attr_reader :id, :done, :error, :created_at, :created_by, :modified_at, :text

    BASE_URL = 'https://operation.api.cloud.yandex.net/operations'
    
    def initialize(operation)
      operation.to_h => { id:, done:, createdAt: created_at, createdBy: created_by, modifiedAt: modified_at }
      @id = id
      @done = done
      @created_at = created_at
      @created_by = created_by
      @modified_at = modified_at

      @error = operation.error if operation.error
      set_response(operation.response) if operation.response
    end

    def self.fetch(operation_id)
      client = Client.new(BASE_URL, :json)
      client.get(url: operation_id) => { data:, errors: }
      new(data) unless errors
    end

    def set_response(response)
      @text = response.chunks.map { |ch| ch.alternatives.first.text }.join("\n")
    end

    def to_h
      { id:, done:, error:, created_at:, created_by:, modified_at:, text: }
    end

    def to_json
      to_h.to_json
    end
  end
end