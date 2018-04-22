module Hagma
  module Core
    class Const
      Info = Struct.new(:symbol, :const, :owner, :depth)
      def cache
        @cache ||= []
      end

      def class_modules
        @class_module ||= []
      end

      def consts
        @consts ||= []
      end

      def initialize(klass = Object)
        @klass = klass
      end

      def enumerate_from_object
        enumerate(@klass, 0)
      end

      def enumerate(klass, level = 0)
        klass.constants(false).map do |symbol|
          kls = klass.const_get(symbol)
          next if cache.include?(kls)
          if kls.class.ancestors.include?(Module)
            class_modules << Info.new(symbol, kls, klass, level)
            cache << kls
            enumerate(kls, level + 1)
          else
            consts << Info.new(symbol, kls, klass, level)
          end
        end
      end
    end
  end
end
