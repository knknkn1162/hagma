require 'hagma/hook'

# reinforce hook method in BasicObject
class Class
  extend Hagma::Hook
  class_event :inherited
end
