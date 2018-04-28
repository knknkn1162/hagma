module TestCase
  class BaseRefinedClass; end
  module BaseRefinementModule
    refine BaseRefinedClass do
      def base_instance_method; end
    end
  end
end
