module TestCase
  # :nodoc:
  class SuperClass
    def base_instance_method; end
    class << self
      def base_singleton_method; end
    end
  end

  class BaseInherited < SuperClass
    def inherited_instance_method; end
    class << self
      def inherited_singleton_method; end
    end
  end
end
