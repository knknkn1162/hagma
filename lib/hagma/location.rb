require 'hagma/source_analyzer'
require 'forwardable'

module Hagma
  # generalized class in Thread::Backtrace::Location & return value of (Method|UnboundMethod)#source_location
  class Location
    attr_reader :absolute_path, :base_label
    extend Forwardable
    delegate %i[absolute_path lineno] => :@source_analyzer

    def initialize(**args)
      @base_label = args[:base_label]
      @label = args[:label]
      @source_analyzer = SourceAnalyzer.new(args[:absolute_path], args[:lineno]) if args[:absolute_path]
    end
  end
end
