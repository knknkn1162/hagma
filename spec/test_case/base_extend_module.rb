
module TestCase
  module ExtendedModule
    def extended_instance_method; end
    class << self
      def extended_singleton_method; end
    end
  end
  module BaseExtendModule
    extend ExtendedModule
    def base_instance_method; end
    class << self
      def base_singleton_method; end
    end
  end
end
