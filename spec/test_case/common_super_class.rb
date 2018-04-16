module TestCase
  # :nodoc:
  class CommonSuperClass
    def common_instance_method; end
    class << self
      def common_singleton_method; end
    end
  end
end
