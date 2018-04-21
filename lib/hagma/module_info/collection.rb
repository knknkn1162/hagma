require 'hagma/module_info'

module Hagma
  # store information on the designated module
  class ModuleInfo
    class Collection
      # @param module_collection
      def initialize(module_collection)
        @module_collection = module_collection
      end

      def keys
        @module_collection.keys
      end

      def chain(owner)
        @chain ||= {}
        @chain[owner] ||= @module_collection[owner][:backward].reverse + [ModuleInfo.dummy] + @module_collection[owner][:forward].reverse
      end

      def filter_with_target(owner)
        module_info_list.select { |module_info| module_info.target == owner }
      end

      def module_info_list
        @module_info_list ||= @module_collection.map { |_, modules| modules[:backward] + modules[:forward] }.flatten
      end

      def linked_ancestors(owner)
        _linked_ancestors(ModuleInfo.root(owner))
      end

      # @return [List[ModuleInfo]] get ancestors which element is ModuleInfo. To get the normal ancestors, exec ModuleInfo.ancestors(owner).map(&:owner).
      def ancestors(owner)
        @ancestors ||= {}
        res = linked_ancestors(owner).flatten
        @ancestors[owner] ||= res + res.last.target.ancestors[1..-1].map { |klass| ModuleInfo.new(klass, nil, nil) }
      end

      private

      def _linked_ancestors(module_info)
        chain(module_info.target).map do |ancestor_module_info|
          if ancestor_module_info.target.nil?
            target_info
          else
            _linked_ancestors ancestor_module_info
          end
        end
      end
    end
  end
end
