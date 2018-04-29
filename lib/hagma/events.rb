require 'hagma/method_info/collection'
require 'hagma/module_info/collection'

module Hagma
  # Add method or module event and stores
  module Events
    autoload :Summary, 'hagma/events/summary'
    class << self
      def method_collection
        @method_collection ||= MethodInfo::Collection.new
      end

      def module_collection
        @module_collection ||= ModuleInfo::Collection.new
      end

      # @param method [Symbol]
      # @param owner [Constant] Class or Module to which the method belongs.
      # @param hook [Symbol] The form of /\A(singleton_)?method_(added|removed|undefined)\z/
      def add_method_event(method, owner, hook)
        owner, hook =
          if hook.to_s.include?('singleton')
            # the number 10 is the the number of characters, `singleton_`.
            [owner.singleton_class, hook.to_s[10..-1].to_sym]
          else
            [owner, hook]
          end
        method_collection.push(method, owner, hook)
      end

      # @param mod [Symbol]
      # @param owner [Constant] Class or Module to which the method belongs.
      # @param hook [Symbol] The form of /\A(included|extended|prepended|refined)\?\z/
      def add_module_event(mod, owner, hook)
        module_collection.push(mod, owner, hook)
      end

      # @param super_class [Class] super_class
      # @param owner [Class] subclass
      # @param hook [Symbol] The form of /\A(inherited)\?\z/
      def add_class_event(super_class, owner, hook)
        3.times do
          module_collection.push(mod, owner, hook)
          # update variable
          super_class = super_class.singleton_class
          owner = owner.singleton_class
        end
      end

      # @param mod [Module] refinement module
      def add_refinement_module(mod)
        # this variable is like `[#<refinement:Array@ArrayExt>, Array, Object, BasicObject]`
        class_ancestors = mod.ancestors - mod.included_modules
        # Ruby does not have `Module#refined`, so we invoke Events::add_module_event directly instead.
        add_module_event(class_ancestors[0], class_ancestors[1], :refined)
      end
    end
  end
end
