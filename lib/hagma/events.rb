require 'hagma/method_info'
require 'hagma/module_info'
require 'hagma/singleton'

module Hagma
  # Add method or module event and stores
  module Events
    autoload :Summary, 'hagma/events/summary'
    class << self
      def add_method_event(method, owner, hook)
        if hook.to_s.include?('singleton')
          singleton = owner.singleton_class
          MethodInfo.new(method, singleton, hook.to_s[10..-1].to_sym).push
          Singleton.desingleton[singleton] ||= owner
        else
          MethodInfo.new(method, owner, hook).push
        end
      end

      def add_module_event(mod, owner, hook)
        ModuleInfo.new(mod, owner, hook).push
      end
    end
  end
end
