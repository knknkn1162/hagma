require 'hagma/method_info'

module Hagma
  # store information on the designated module
  class MethodInfo
    class Collection
      # @param collection
      def initialize(collection)
        @method_collection = collection
      end

      def list
        @list ||= @method_collection.map { |_, mets| mets }.flatten
      end

      def owner_methods(target)
        @method_collection[target]
      end
    end
  end
end
