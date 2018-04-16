require 'test_case/common_module'

module TestCase
  class CommonPrependClass
    prepend CommonModule
    def common_instance_method; end
    class << self
      def common_singleton_method; end
    end
  end
end
