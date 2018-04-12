require 'hagma/events'

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
      # @param owner [ModuleInfo|Symbol]
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
        @mixins ||= @module_collection.map do |owner, module_info|
          [owner, module_info.group_by(&:hook)]
        end.to_h
      end

      # @return [Hash] the form of {owner: [OwnerMethods]}
      def owner_stats
        (mixins.keys + @method_collection.map(&:owner)).uniq.map do |owner|
          owner_methods = @method_collection.select { |method_info| method_info.owner == owner }
          [owner, OwnerMethods.new(owner, owner_methods, mixins[owner][:included], mixins[owner][:extended], mixins[owner][:prepended])]
        end.to_h
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
        res = {}
        klass.ancestors.map.with_index do |ancestor, idx|
          # prepend
          if ancestor.class == Class
            owner_stats[ancestor].prepended.select(&:instance?).each do |method_info|
              res[method_info.name] ||= MethodStat.new(method_info, module_info, idx)
            end
          end
          # instance
          owner_stats[ancestor].base.select(&:instance?).each do |method_info|
            res[method_info.name] ||= MethodStat.new(method_info, module_info, idx)
          end
        end
        res
      end

      # @return [Hash] the form of {singleton_method1: [MethodStat]}
      def singleton_stat(klass)
        res = {}
        # tracesingleton chain
        klass.ancestors.map.with_index do |ancestor, idx|
          # res = method_stats(ancestor, :base, :singleton).update(res)
          owner_stats[ancestor].base.select(&:singleton).each do |method_info|
            res[method_info.name] ||= MethodStat(method_info, ancestor, idx)
          end
          next if ancestor.class == Module
          # res = method_stats(ancestor, :extended, :singleton).update(res)
          owner_stats[ancestor].extended.select(&:singleton).each do |method_info|
            res[method_info.name] ||= MethodStat.new(method_info, module_info, idx)
          end
        end
        # trace Class class and its ancestors
        return res if klass.class == Module
        Class.ancestors.map.with_index(klass.ancestors.size) do |ancestor, idx|
          owner_stats[ancestor].base.select(&:instance).each do |method_info|
            res[method_info.name] ||= MethodStat.new(method_info, ancestor, idx)
          end
        end
      end
    end
  end
end
