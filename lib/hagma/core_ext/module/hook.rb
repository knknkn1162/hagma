require 'hagma/hook'

# reinforce hook method in Module class
class Module
  extend Hagma::Hook
  method_event :method_added
  method_event :method_removed
  method_event :method_undefined
  module_event :included
  module_event :extended
  module_event :prepended
end
