require 'hagma/method_info'

module Hagma
  # store information on the designated module
  class MethodInfo
    class Collection
      # @param module_collection
      def initialize(module_collection)
        @method_collection = module_collection
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
