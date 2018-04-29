require 'hagma/method_catcher'
require 'hagma/const_catcher'

module Hagma
  # add core methods into MethodInfo.collection
  class Initializer
    def initialize
      @const_catcher = ConstCatcher.new
    end

    def class_modules
      @const_catcher.enumerate.class_modules
    end

    def collect_methods
      res = MethodCatcher.new
      class_modules.each do |method_catcher|
        res.merge!(method_catcher)
      end
      res
    end
  end
end
