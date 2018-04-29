require 'hagma/method_info'

module Hagma
  class MethodInfo
    # store information on the designated module
    class Collection
      attr_reader :collection
      def initialize
        @collection = Hash.new { |h, k| h[k] = [] }
      end

      def push(method, owner, hook, access_controller = nil, backtrace = false)
        @collection[owner] << MethodInfo.new(method, owner, hook, access_controller, backtrace)
      end

      def list
        @list ||= @collection.map { |_, mets| mets }.flatten
      end

      def owner_methods(owner)
        @collection[owner]
      end

      def merge!(other_collection)
        other_collection.collection.each do |owner, methods|
          @collection[owner] += methods
        end
        self
      end
    end
  end
end
