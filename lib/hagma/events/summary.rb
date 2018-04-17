module Hagma
  module Events
    # the module summaries module_collection & method_collection
    class Summary
      # @param owner [Symbol]
      # @param base [list[MethodInfo]]
      # @param included [list[MethodInfo]]
      # @param excluded [list[MethodInfo]]
      # @param prepended [list[MethodInfo]]
      OwnerMethods = Struct.new(:owner, :base, :included, :extended, :prepended)
      # @param method_info [MethodInfo]
      # @param owner [Constant] The ancestor that the method has.
      # @param level Integer
      MethodStat = Struct.new(:method_info, :owner, :level)

      class << self
        def merge!(src, dst)
          dst.keys.each do |method_name|
            src[method_name] += dst[method_name]
          end
          src
        end
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

      # The result includes klass's ancestors different from #klass_stat
      # @param klass [Class|Module] class or module
      # @param type [Symbol] :singleton or :instance or nil(all)
      # @return [Hash] hash keys are :instance or :singleton or both and its value is MethodStat
      def type_stats(klass, type = nil)
        types = type.nil? ? %i[instance singleton] : type
        types.map do |t|
          [t, stats(t == :singleton ? klass.singleton_class : klass)]
        end.to_h
      end

      # get the instance_method information including ancestors
      # @return [Hash] the form of {instance_method1: [MethodStat]}
      def stats(klass)
        res = Hash.new { |h, k| h[k] = [] }
        klass.ancestors.map.with_index(-offset(klass)) do |ancestor, level|
          # instance
          @method_collection[ancestor].map do |method_info|
            res[method_info.name] << MethodStat.new(method_info, ancestor, level)
          end
        end
        res
      end

      # @return [Integer]
      def offset(klass)
        klass.ancestors.index { |ancestor| ancestor == klass }
      end
    end
  end
end
