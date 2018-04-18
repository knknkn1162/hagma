# @author Kenta Nakajima

class Module
  extend Hagma::Hook
  method_event :method_added
  method_event :method_removed
  method_event :method_undefined
  module_event :included
  module_event :extended
  module_event :prepended
end

class BasicObject
  extend ::Hagma::Hook
  method_event :singleton_method_added
  method_event :singleton_method_removed
  method_event :singleton_method_undefined
end

class Class
  extend Hagma::Hook
  class_event :inherited
end
