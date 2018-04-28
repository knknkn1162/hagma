require 'hagma/events'

module Hagma
  # Catch method or module added or removed or deleted
  module Hook
    def method_event(hook)
      define_method(hook) do |mth|
        Events.add_method_event(mth, self, hook)
        # Check if `self` owner is refinement module or not

        if to_s[2..-1].start_with?('refinement:')
          # this variable is like `[#<refinement:Array@ArrayExt>, Array, Object, BasicObject]`
          class_ancestors = ancestors - included_modules
          # Ruby does not have `Module#refined`, so we invoke Events::add_module_event directly instead.
          Events.add_module_event(class_ancestors[0], class_ancestors[1], :refined)
        end
      end
    end

    # overload `Module#included`, `Module#extended`, `Module#prepended`
    def module_event(hook)
      define_method(hook) do |owner|
        Events.add_module_event(self, owner, hook)
      end
    end

    def class_event(hook)
      define_method(hook) do |subclass|
        Events.add_class_event(self, subclass, hook)
      end
    end
  end
end
