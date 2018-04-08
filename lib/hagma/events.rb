require 'hagma/method_info'
require 'hagma/module_info'

module Hagma
  # Add method or module event and stores
  class Events
    class << self
      def method_collection
        @method_collection ||= Hash.new { |h, k| h[k] = [] }
      end

      def module_collection
        @module_collection ||= Hash.new { |h, k| h[k] = [] }
      end

      def add_method_event(method, owner, hook)
        method_collection[owner] << MethodInfo.new(method, owner, hook) do |stack_level|
          Backtrace::Location.locations(stack_level + 1)
        end
      end

      def add_module_event(mod, owner, hook)
        module_collection[owner] << ModuleInfo.new(mod, owner, hook) do |stack_level|
          Backtrace::Location.locations(stack_level + 1)
        end
      end
    end
  end
end
