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
    end
    name? :singleton
    name? :instance

    def initialize(mth, owner, hook, access_controller = nil, backtrace = true)
      @name = mth
      @owner = owner
      @hook = hook
      @access_controller = access_controller.nil? ? _access_controller : access_controller
      @backtrace_locations = Backtrace::Location.locations BACKTRACE_METHOD_NUMBER if backtrace
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

    private

    def _access_controller
      %i[public protected private].find do |controller|
        owner.send("#{controller}_method_defined?", name)
      end
    end
  end
end
