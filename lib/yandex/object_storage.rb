# frozen_string_literal: true

require 'aws-sdk-s3'

module Yandex
  class ObjectStorage
    def initialize
      credentials = Aws::Credentials.new(
        Yandex.config[:access_key_id],
        Yandex.config[:access_key]
      )

      Yandex.config[:s3] => { region:, endpoint: }

      @client = Aws::S3::Client.new(
        credentials:,
        region:,
        endpoint:
      )
    end

    def put(file, filename, bucket = nil)
      bucket = bucket || Yandex.config[:s3][:bucket]

      @client.put_object(
        bucket:,
        key: filename,
        body: file
      )

      self.class.full_path(filename)
    end

    def self.full_path(filename)
      Yandex.config[:s3] => { endpoint:, bucket: }
      "#{endpoint}/#{bucket}/#{filename}"
    end
  end
end