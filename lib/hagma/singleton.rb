module Hagma
  class Singleton
    class << self
      def desingleton
        @desingleton ||= {}
      end
    end
  end
end
