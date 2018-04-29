require 'hagma/method_info'

module Hagma
  # Class for collecting method
  class MethodCatcher
    def initialize
      @method_collection = []
    end

    def push(method, owner, hook)
      @method_collection << MethodInfo.new(method, owner, hook)
    end
  end
end
