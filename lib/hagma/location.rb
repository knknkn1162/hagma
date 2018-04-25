require 'hagma/extractor'

module Hagma
  # generalized class in Thread::Backtrace::Location & return value of (Method|UnboundMethod)#source_location
  class Location
    attr_reader :label, :base_label, :extractor

    def initialize(**args)
      @base_label = args[:base_label]
      @label = args[:label]
      # lineno starts with 1
      @extractor = Extractor.new(args[:absolute_path], args[:lineno]) if args[:absolute_path]
    end

    def absolute_path
      @extractor&.absolute_path
    end

    def lineno
      @extractor&.absolute_path
    end
  end
end
