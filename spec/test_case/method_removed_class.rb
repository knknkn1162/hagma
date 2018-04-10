module TestCase
  # :nodoc:
  class MethodRemovedClass
    def base_instance_method; end
    class << self
      def base_singleton_method; end
    end

    remove_method :base_instance_method
    class << self
      remove_method :base_singleton_method
    end
  end
end
