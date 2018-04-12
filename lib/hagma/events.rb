require 'hagma/method_info'
require 'hagma/module_info'

module Hagma
  # Add method or module event and stores
  module Events
    class << self
      def add_method_event(method, owner, hook)
        MethodInfo.new(method, owner, hook).push
      end

      def add_module_event(mod, owner, hook)
        ModuleInfo.new(mod, owner, hook).push
      end
    end
  end
end
