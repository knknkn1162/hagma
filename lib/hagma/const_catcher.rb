require 'hagma/const_info'

module Hagma
  # Class for collecting constants
  class ConstCatcher
    def cache
      @cache ||= []
    end

    def class_modules
      @class_modules ||= []
    end

    def consts
      @consts ||= []
    end

    def initialize(klass = Object)
      @klass = klass
    end

    def enumerate
      _enumerate(@klass, 0)
    end

    # enumerate constants recursively
    # @param klass [Class|Module]
    # @return ConstCatcher return self
    def _enumerate(klass, level = 0)
      klass.constants(false).map do |symbol|
        kls = klass.const_get(symbol)
        next if cache.include?(kls)
        if kls.class.ancestors.include?(Module)
          class_modules << ConstInfo.new(symbol, kls, klass, level)
          cache << kls
          _enumerate(kls, level + 1)
        else
          consts << ConstInfo.new(symbol, kls, klass, level)
        end
      end
      self
    end
  end
end
