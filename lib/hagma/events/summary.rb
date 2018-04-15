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
      # @param method [MethodInfo]
      # @param owner [Constant]
      # @param level Integer
      MethodStat = Struct.new(:method, :owner, :level)

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

      # @return [Hash] the form of {owner: [OwnerMethods]}
      def klass_stat klass
        OwnerMethods.new(klass, @method_collection[klass], mixins[klass][:included], mixins[klass][:extended], mixins[klass][:prepended])
      end

      # The result includes klass's ancestors different from #owner_stats
      # @param klass [Class|Module] class or module
      # @param type [Symbol] :singleton or :instance or nil(all)
      # @return [Hash] hash keys are :instance or :singleton or both and its value is MethodStat
      def stat(klass, type = nil)
        types = type.nil? ? %i[instance singleton] : type
        types.map do |t|
          [t, __send__("#{t}_stat", klass)]
        end.to_h
      end

      # @return [Hash] the form of {instance_method1: [MethodStat]}
      def instance_stat(klass)
        res = Hash.new { |h, k| h[k] = [] }
        klass.ancestors.map.with_index do |ancestor, idx|
          # prepend
          if ancestor.class == Class
            if (ancestor_prepended = owner_stats[ancestor]&.prepended)
              ancestor_prepended.select(&:instance?).each do |module_info|
                module_functions[module_info.mod].each do |method_info|
                  # we use `<<`, because the method may jump to super_method
                  res[method_info.name] << MethodStat.new(method_info, ancestor, idx)
                end
              end
            end
          end
          # instance
          if (ancestor_base = owner_stats[ancestor]&.base)
            ancestor_base.select(&:instance?).each do |method_info|
              res[method_info.name] << MethodStat.new(method_info, ancestor, idx)
            end
          end
        end
        res
      end

      # @return [Hash] the form of {singleton_method1: [MethodStat]}
      def singleton_stat(klass)
        res = Hash.new { |h, k| h[k] = [] }
        # tracesingleton chain
        klass.ancestors.map.with_index do |ancestor, idx|
          if (ancestor_base = owner_stats[ancestor]&.base)
            ancestor_base.select(&:singleton?).each do |method_info|
              res[method_info.name] << MethodStat.new(method_info, ancestor, idx)
            end
          end
          next if ancestor.class == Module
          if (ancestor_extended = owner_stats[ancestor]&.extended)
            ancestor_extended.each do |module_info|
              module_functions[module_info.mod].each do |method_info|
                res[method_info.name] << MethodStat.new(method_info, ancestor, idx)
              end
            end
          end
        end
        # trace Class class and its ancestors
        return res if klass.class == Module
        return res unless klass.singleton_class?
        Class.ancestors.map.with_index(klass.ancestors.size) do |ancestor, idx|
          if (ancestor_base = owner_stats[ancestor]&.base)
            ancestor_base.select(&:instance?).each do |method_info|
              res[method_info.name] << MethodStat.new(method_info, ancestor, idx)
            end
          end
        end
      end

      def module_functions
        @module_functions ||= begin
          res = Hash.new { |h, k| h[k] = [] }
          @method_collection.each do |owner, mets|
            next if owner.class == Module
            res[owner] = mets.select(&:singleton?)
          end
          res
        end
      end
    end
  end
end
