module TestCase
  # see the example in http://ruby-doc.org/core-2.5.0/Module.html#method-i-undef_method
  class SuperUndefinedClass
    def base_instance_method; end
    class << self
      def base_singleton_method; end
    end
  end

  # :nodoc:
  class MethodUndefinedClass < SuperUndefinedClass
    def base_instance_method; end
    class << self
      def base_singleton_method; end
    end
  end

  # reopen class
  class MethodUndefinedClass
    undef_method :base_instance_method # prevent any calls to 'hello'
    class << self
      undef_method :base_singleton_method
    end
  end
end
