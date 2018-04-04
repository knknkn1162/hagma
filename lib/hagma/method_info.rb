module Hagma
  # store information on the designated method and you can analyze it.
  class MethodInfo
    attr_reader :klass, :name, :hook
    def initialize(mth, klass, hook)
      @name = mth
      @klass = klass
      @hook = hook
    end

    def analyze
      find_method.tap do |method|
        if (loc = method.source_location)
          @location = SourceAnalyzer.new(*loc)
        end
        @caller_locations = caller_locations(5)
        @owner = method.owner
        @receiver = method.receiver
        @params = method.parameters
        @original_name = method.original_name
      end
    end

    def find_method
      klass.__send__("#{method_type}_method", name)
    end

    def method_type
      @method_type ||= hook.to_s.include?('singleton') ? :singleton : :instance
    end
  end
end
