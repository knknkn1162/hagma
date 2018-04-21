module Hagma
  module Events
    # the module summaries module_collection & method_collection
    class Summary
      # @param method_info [MethodInfo]
      # @param owner ModuleInfo The ancestor that the method has.
      # @param level Integer
      MethodStat = Struct.new(:method_info, :owner, :level)

      class ModuleNotFoundError < StandardError; end
      class << self
        def merge!(src, dst)
          dst.keys.each do |method_name|
            src[method_name] += dst[method_name]
          end
          src
        end

        # @return [Integer]
        def offset(klass)
          klass.ancestors.index { |ancestor| ancestor == klass }
        end
      end

      def chain(owner)
        @chain ||= {}
        @chain[owner] ||= @module_collection[owner][:backward].reverse + [ModuleInfo.dummy] + @module_collection[owner][:forward].reverse
      end

      def module_info_list
        @module_info_list ||= @module_collection.map { |_, modules| modules[:backward] + modules[:forward] }.flatten
      end

      def find_module_info(method_info)
        module_info_list.select { |module_info| module_info.target == method_info.owner }.find { |module_info| @method_collection[module_info.target].include?(method_info) }
      end

      def method_info_list
        @method_info_list ||= @method_collection.map { |_, mets| mets }.flatten
      end

      def _linked_ancestors(target_info)
        chain(target_info.target).map do |ancestor_module_info|
          if ancestor_module_info.target.nil?
            target_info
          else
            _linked_ancestors ancestor_module_info
          end
        end
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

      # @param method_collection [list[MethodInfo]]
      # @param module_collection [list[ModuleInfo]]
      def initialize(method_collection, module_collection)
        @method_collection = method_collection
        @module_collection = module_collection
      end

      # @return [Hash] {owner1: {extended: [module_info], ...}, owner2: {...} }
      def mixins
        @mixins ||= begin
          hash = Hash.new { |h, k| h[k] = {} }
          @module_collection.each do |owner, module_info|
            hash[owner] = module_info.group_by(&:hook)
          end
          hash
        end
      end

      # search method_info objects from the class
      # @param klass [Class|Module] class or module
      # @param type [Symbol] :singleton or :instance or nil(all)
      # @return [Hash] hash keys are :instance or :singleton or both and its value is MethodStat
      def lookup_methods(klass, type = nil)
        types = type.nil? ? %i[instance singleton] : type
        types.map do |t|
          [t, method_stats(t == :singleton ? klass.singleton_class : klass)]
        end.to_h
      end

      # search method_info objects from the method name
      # @param met [Symbol|String] method name
      # @return [Hash] hash which key are class and value is method_info.
      def lookup_classes(met)
        new_klasses = @module_collection.keys
        res = Hash.new { |h, k| h[k] = [] }
        method_info_list.select { |method_info| method_info.name == met.to_sym }.map do |method_info|
          m_owner = method_info.owner
          # add method_info myself to res
          res[m_owner] << MethodStat.new(method_info, ModuleInfo.root(m_owner), 0)

          owner_module_info = find_module_info(method_info)
          new_klasses.each do |klass|
            next if klass == method_info.owner
            klass_ancestors = klass.ancestors
            if (idx = klass_ancestors.index(method_info.owner))
              raise ModuleNotFoundError if owner_module_info.nil?
              res[klass] << MethodStat.new(method_info, owner_module_info, idx - self.class.offset(klass))
            end
          end
        end
        res
      end

      # get the instance_method information including ancestors
      # @return [Hash] the form of {instance_method1: [MethodStat]}
      def method_stats(klass)
        res = Hash.new { |h, k| h[k] = [] }
        ancestors(klass).map.with_index(-self.class.offset(klass)) do |module_info, level|
          # instance
          @method_collection[module_info.target].map do |method_info|
            res[method_info.name] << MethodStat.new(method_info, module_info, level)
          end
        end
        res
      end
    end
  end
end
