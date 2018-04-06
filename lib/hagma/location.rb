require 'hagma/source_analyzer'

module Hagma
  # generalized class in Thread::Backtrace::Location & return value of (Method|UnboundMethod)#source_location
  class Location
    attr_reader :label, :base_label

    def initialize(**args)
      @base_label = args[:base_label]
      @label = args[:label]
      @source_analyzer = SourceAnalyzer.new(args[:absolute_path], args[:lineno]) if args[:absolute_path]
    end

    def absolute_path
      @source_analyzer&.absolute_path
    end

    def lineno
      @source_analyzer&.absolute_path
    end
  end
end
