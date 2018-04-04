require 'hagma/location'
require 'hagma/backtrace/location'

module Hagma
  # store information on the designated method and you can analyze it.
  class MethodInfo
    attr_reader :klass, :name, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(mth, klass, hook, backtrace = true)
      @name = mth
      @klass = klass
      @hook = hook
      # trace before Hagma::Hook::method_event
      @backtrace_locations = Backtrace::Location.locations(BACKTRACE_METHOD_NUMBER) if backtrace
    end

    def analyze
      find_method.tap do |method|
        loc = method.source_location
        @location = Location.new(absolute_path: File.expand_path(loc[0]), lineno: loc[1]) if loc
        @owner = method.owner
        @receiver = method.receiver unless method.class == UnboundMethod
        @params = method.parameters
        @original_name = method.original_name
      end
    end

    # @note Module#instance_method returns UnboundMethod class
    def find_method
      klass.__send__("#{method_type}_method", name)
    end

    def method_type
      @method_type ||= hook.to_s.include?('singleton') ? :singleton : :instance
    end
  end
end
