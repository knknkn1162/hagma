require 'hagma/hook'

# @author Kenta Nakajima
# maybe use prepend than extend
class Module
  extend Hagma::Hook
  method_event :method_added
  method_event :method_removed
  module_event :included
  module_event :extended
  module_event :prepended
end

# maybe use prepend than extend
class BasicObject
  extend ::Hagma::Hook
  method_event :singleton_method_added
  method_event :singleton_method_removed
end
