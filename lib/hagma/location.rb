module Hagma
  # generalized class in Thread::Backtrace::Location & return value of (Method|UnboundMethod)#source_location
  class Location
    attr_reader :absolute_path, :base_label, :label, :lineno
    def initialize(**args)
      @absolute_path = args[:absolute_path]
      @base_label = args[:base_label]
      @label = args[:label]
      @lineno = args[:lineno]
    end
  end
end
