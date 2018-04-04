require 'hagma/method_info'
require 'hagma/module_info'

module Hagma
  # Add method or module event and stores
  class Events
    class << self
      def methods
        @methods ||= []
      end

      def modules
        @modules ||= []
      end

      def add_method_event(method, klass, hook)
        methods << MethodInfo.new(method, klass, hook)
      end

      def add_module_event(mod, owner, hook)
        modules << ModuleInfo.new(mod, owner, hook)
      end
    end
  end
end
