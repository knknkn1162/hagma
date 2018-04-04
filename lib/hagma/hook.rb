require 'hagma/events'

module Hagma
  # Catch method or module added or removed or deleted
  module Hook
    def method_event(hook)
      define_method(hook) do |mth|
        Events.add_method_event(mth, self, hook)
      end
    end

    def module_event(hook)
      define_method(hook) do |owner|
        Events.add_module_event(self, owner, hook)
      end
    end
  end
end
