require 'hagma/module_info'

module Hagma
  class ModuleInfo
    # store information on the designated module
    class Collection
      attr_reader :collection
      def initialize
        @collection ||= Hash.new { |h, k| h[k] = { backward: [], forward: [], leftmost: [] } }
      end

      def push(mod, owner, hook)
        module_info = ModuleInfo.new(mod, owner, hook)
        collection[module_info.chain_owner][module_info.position] << module_info
      end

      def keys
        collection.keys
      end

      def chain(owner)
        @chain ||= {}
        @chain[owner] ||= collection[owner][:backward].reverse + [ModuleInfo.dummy] + collection[owner][:forward].reverse
      end

      def filter_with_target(owner)
        list.select { |module_info| module_info.target == owner }
      end

      def list
        @list ||= collection.map { |_, modules| modules.values.flatten }.flatten
      end

      def linked_ancestors(owner)
        _linked_ancestors(ModuleInfo.root(owner))
      end

      # @return [List[ModuleInfo]] get ancestors which element is ModuleInfo. To get the normal ancestors, exec ModuleInfo.ancestors(owner).map(&:owner).
      def ancestors(owner)
        @ancestors ||= {}
        res = linked_ancestors(owner).flatten
        suffix =
          if owner.singleton_class? && owner.superclass == Module
            Module.ancestors.map { |klass| ModuleInfo.root(klass) }
          else
            res.last.target.ancestors[1..-1].map { |klass| ModuleInfo.root(klass) }
          end

        # TODO: make sure that lookup logic is correct
        @ancestors[owner] ||= refinement_modules(owner) + res + suffix
      end

      def refinement_modules(owner)
        collection[owner][:leftmost]
      end

      private

      def _linked_ancestors(module_info)
        chain(module_info.target).map do |ancestor_module_info|
          if ancestor_module_info.target.nil?
            module_info
          else
            _linked_ancestors ancestor_module_info
          end
        end
      end
    end
  end
end
