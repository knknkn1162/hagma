require 'hagma/hook'

# reinforce hook method in BasicObject
class BasicObject
  extend ::Hagma::Hook
  method_event :singleton_method_added
  method_event :singleton_method_removed
  method_event :singleton_method_undefined
end
