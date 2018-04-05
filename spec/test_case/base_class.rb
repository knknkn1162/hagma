module Hagma
  module TestCase
    class BaseClass
      def base_instance_method; end
      class << self
        def base_singleton_method; end
      end
    end
  end
end
