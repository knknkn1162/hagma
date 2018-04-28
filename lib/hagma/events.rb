require 'hagma/method_info'
require 'hagma/module_info'
require 'hagma/singleton'

module Hagma
  # Add method or module event and stores
  module Events
    autoload :Summary, 'hagma/events/summary'
    class << self
      def add_method_event(method, owner, hook)
        owner, hook =
          if hook.to_s.include?('singleton')
            # Singleton.desingleton[singleton] ||= owner
            # hook is the form of (singleton_)?_method_(added|removed|undefined)
            # the number 10 is the the number of characters, `singleton_`.
            [owner.singleton_class, hook.to_s[10..-1].to_sym]
          else
            [owner, hook]
          end
        MethodInfo.new(method, owner, hook).push
      end

      def add_module_event(mod, owner, hook)
        ModuleInfo.new(mod, owner, hook).push
      end

      def add_class_event(super_class, owner, hook)
        3.times do
          ModuleInfo.new(super_class, owner, hook).push
          super_class = super_class.singleton_class
          owner = owner.singleton_class
        end
      end

      def add_refinement_module(mod)
        # this variable is like `[#<refinement:Array@ArrayExt>, Array, Object, BasicObject]`
        class_ancestors = mod.ancestors - mod.included_modules
        # Ruby does not have `Module#refined`, so we invoke Events::add_module_event directly instead.
        add_module_event(class_ancestors[0], class_ancestors[1], :refined)
      end
    end
  end
end
