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
      def klass_stats(klass, type = nil)
        types = type.nil? ? %i[instance singleton] : type
        types.map do |t|
          [t, __send__("#{t}_stats", klass)]
        end.to_h
      end

      # get the instance_method information including ancestors
      # @return [Hash] the form of {instance_method1: [MethodStat]}
      def instance_stats(klass)
        res = Hash.new { |h, k| h[k] = [] }
        klass.ancestors.map.with_index do |ancestor, level|
          type = :instance?
          # prepend
          if ancestor.class == Class
            prepended_stats = get_module_stats(mixins[ancestor][:prepended] || [], ancestor, type, level)
            self.class.merge!(res, prepended_stats)
          end
          # instance
          base_stats = get_method_stats(@method_collection[ancestor] || [], ancestor, type, level)
          self.class.merge!(res, base_stats)
        end
        res
      end

      # get the singleton_method information including ancestors
      # @return [Hash] the form of {singleton_method1: [MethodStat]}
      def singleton_stats(klass)
        klass.class == Module ? module_singleton_stats(klass) : class_singleton_stats(klass)
      end

      # @return [Hash] the form of {singleton_method1: [MethodStat]}
      def module_singleton_stats(klass)
        res = Hash.new { |h, k| h[k] = [] }
        res.update(get_method_stats(@method_collection[klass] || [], klass, :singleton?, 0))
      end

      # @return [Hash] the form of {singleton_method1: [MethodStat]}
      def class_singleton_stats(klass)
        res = Hash.new { |h, k| h[k] = [] }
        # trace singleton chain
        klass.ancestors.map.with_index do |ancestor, level|
          next if ancestor.class == Module
          # base
          base_stats = get_method_stats(@method_collection[ancestor] || [], ancestor, :singleton?, level)
          self.class.merge!(res, base_stats)
          # extended
          extended_stats = get_module_stats(mixins[ancestor][:extended] || [], ancestor, :instance?, level)
          self.class.merge!(res, extended_stats)
        end
        # trace Class class and its ancestors
        klass.singleton_class? ? self.class.merge(res, instance_stats(Class)) : res
      end

      # @return [Hash] form of { Class: List[MethodInfo] }
      def module_functions
        @module_functions ||= begin
          res = Hash.new { |h, k| h[k] = [] }
          @method_collection.each do |owner, mets|
            next unless owner.class == Module
            res[owner] = mets.select(&:instance?)
          end
          res
        end
      end

      def get_module_stats(modules, klass, type, level)
        res = Hash.new { |h, k| h[k] = [] }
        modules.each do |module_info|
          method_stats = get_method_stats(module_functions[module_info.mod] || [], klass, type, level)
          self.class.merge!(res, method_stats)
        end
        res
      end

      def get_method_stats(methods, klass, type, level)
        res = Hash.new { |h, k| h[k] = [] }
        methods.select { |method_info| method_info.__send__(type) }.each do |method_info|
          res[method_info.name] << MethodStat.new(method_info, klass, level)
        end
        res
      end
    end
  end
end
