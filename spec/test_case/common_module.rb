module TestCase
  module CommonModule
    def common_instance_method; end
    class << self
      def common_singleton_method; end
    end
  end
end
