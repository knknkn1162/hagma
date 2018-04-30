require 'hagma/method_info'

module Hagma
  class MethodInfo
    # store information on the designated module
    class Collection
      attr_reader :collection
      def initialize
        @collection = Hash.new { |h1, k1| h1[k1] = Hash.new { |h2, k2| h2[k2] = [] } }
      end

      def push(method, owner, hook, access_controller = nil, backtrace = false)
        @collection[owner][method] << MethodInfo.new(method, owner, hook, access_controller, backtrace)
      end

      def list
        @list = []
        @list = @collection.map do |_, mets|
          mets.map do |_met, method_info|
            method_info
          end
        end.flatten
      end

      def status(owner, met)
        if (method_info = @collection[owner][met].last)
          case method_info.hook
          when :method_added, :core then
            :enable
          when :method_removed then
            :skip
          when :method_undefined then
            :halt
          end
        end
      end

      def owner_methods(owner)
        @collection[owner].values.flatten
      end

      def merge!(other_collection)
        other_collection.collection.each do |owner, mets|
          mets.each do |met, methods|
            @collection[owner][met] += methods
          end
        end
        self
      end
    end
  end
end
