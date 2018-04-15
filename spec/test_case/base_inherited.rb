module TestCase
  # :nodoc:
  class SuperClass
    def common_instance_method; end
    class << self
      def common_singleton_method; end
    end
  end

  class BaseInherited < SuperClass
    def common_instance_method; end
    class << self
      def common_singleton_method; end
    end
  end
end
