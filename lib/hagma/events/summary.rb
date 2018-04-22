require 'hagma/module_info/collection'
require 'hagma/method_info/collection'

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

      def find_module_info(method_info)
        @module_collection.filter_with_target(method_info.owner).find { |module_info| @method_collection.owner_methods(module_info.target).include?(method_info) }
      end

      # @param method_collection [list[MethodInfo]]
      # @param module_collection [list[ModuleInfo]]
      def initialize(method_collection, module_collection)
        @method_collection = MethodInfo::Collection.new(method_collection)
        @module_collection = ModuleInfo::Collection.new(module_collection)
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
      # @return [Hash] hash which key are class and value is MethodStat
      def lookup_classes(met)
        new_klasses = @module_collection.keys
        res = Hash.new { |h, k| h[k] = [] }
        @method_collection.list.select { |method_info| method_info.name == met.to_sym }.map do |method_info|
          m_owner = method_info.owner
          # add method_info myself to res
          res[m_owner] << MethodStat.new(method_info, ModuleInfo.root(m_owner), 0)

          owner_module_info = find_module_info(method_info)
          new_klasses.each do |klass|
            next if klass == method_info.owner
            if (idx = klass.ancestors.index(method_info.owner))
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
        @module_collection.ancestors(klass).map.with_index(-self.class.offset(klass)) do |module_info, level|
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
