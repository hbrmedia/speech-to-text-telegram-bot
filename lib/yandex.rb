# frozen_string_literal: true

module Yandex
  autoload :ObjectStorage, 'yandex/object_storage'
  autoload :SpeechKit, 'yandex/speech_kit'
  autoload :Client, 'yandex/client'
  autoload :Response, 'yandex/response'
  autoload :Operation, 'yandex/operation'

  class << self
    attr_writer :config

    def config
      @config ||= {}
    end
  end

  module SpeechKit
    autoload :Recognition, 'yandex/speech_kit/recognition'
    autoload :AsyncRecognition, 'yandex/speech_kit/async_recognition'
  end
end