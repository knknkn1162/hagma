require 'test_case/base_module'

module TestCase
  module ExtendedModule
    extend BaseModule
    def extended_instance_method; end
    class << self
      def extended_singleton_method; end
    end
  end
end
