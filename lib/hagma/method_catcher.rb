require 'hagma/method_info'

module Hagma
  # Class for collecting method
  class MethodCatcher
    attr_reader :collection
    def initialize
      @collection = []
    end

    def push(method, owner, hook)
      @collection << MethodInfo.new(method, owner, hook)
    end
  end
end
