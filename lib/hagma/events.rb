require 'hagma/method_info'
require 'hagma/module_info'

module Hagma
  # Add method or module event and stores
  module Events
    class << self
      def method_collection
        @method_collection ||= Hash.new { |h, k| h[k] = [] }
      end

      def add_method_event(method, owner, hook)
        method_collection[owner] << MethodInfo.new(method, owner, hook)
      end

      def add_module_event(mod, owner, hook)
        module_info = ModuleInfo.new(mod, owner, hook)
        module_info.push
      end
    end
  end
end
