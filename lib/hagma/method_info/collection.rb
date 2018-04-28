require 'hagma/method_info'

module Hagma
  # store information on the designated module
  class MethodInfo
    class Collection
      # @param collection
      def initialize(collection)
        @collection = collection
      end

      def list
        @list ||= @collection.map { |_, mets| mets }.flatten
      end

      def owner_methods(target)
        @collection[target]
      end
    end
  end
end
