require 'hagma/events'
require 'hagma/core_ext/module/refine'

module Hagma
  # Catch method or module added or removed or deleted
  module Hook
    def method_event(hook)
      define_method(hook) do |mth|
        owner = self
        Events.add_method_event(mth, owner, hook)
        # Check if `self` owner is refinement module or not
        Events.add_refinement_module(owner) if owner.refine?
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
