require 'test_case/common_super_class'

module TestCase
  class CommonSubClass < CommonSuperClass
    def common_instance_method; end
    class << self
      def common_singleton_method; end
    end
  end
end
