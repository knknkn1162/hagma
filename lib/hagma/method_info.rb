require 'hagma/location'
require 'hagma/backtrace/location'

module Hagma
  # store information on the designated method and you can analyze it.
  class MethodInfo
    attr_reader :name, :owner, :hook, :backtrace_locations
    BACKTRACE_METHOD_NUMBER = 5
    class << self
      def name?(name)
        define_method("#{name}?") do
          method_type == name
        end
      end

      def method_collection
        @method_collection ||= Hash.new { |h, k| h[k] = [] }
      end
    end
    name? :singleton
    name? :instance

    def initialize(mth, owner, hook, access_controller = nil, backtrace = true)
      @name = mth
      @owner = owner
      @hook = hook
      @access_controller = access_controller.nil? ? get_access_controller : access_controller
      @backtrace_locations = Backtrace::Location.locations BACKTRACE_METHOD_NUMBER if backtrace
    end

    def analyze
      find_method.tap do |method|
        loc = method.source_location
        @location = Location.new(absolute_path: File.expand_path(loc[0]), lineno: loc[1]) if loc
        # @owner = method.owner
        @receiver = method.receiver unless method.class == UnboundMethod
        @params = method.parameters
        @original_name = method.original_name
      end
    end

    # @note Module#instance_method returns UnboundMethod class
    def find_method
      owner.__send__("#{method_type}_method", name)
    end

    def method_type
      case hook
      when :method_added, :method_removed, :method_undefined then
        :instance
      when :singleton_method_added, :singleton_method_removed, :singleton_method_undefined then
        :singleton
      end
    end

    def push
      self.class.method_collection[owner] << self
    end

    private

    def get_access_controller
      %i[public protected private].find do |controller|
        owner.send("#{controller}_method_defined?", name)
      end
    end
  end
end
