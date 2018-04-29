require 'hagma/method_info'

module Hagma
  # Class for collecting method
  class MethodCatcher
    attr_reader :collection
    def initialize
      @collection = Hash.new { |h, k| h[k] = [] }
    end

    def push(method, owner, hook, access_controller = nil, backtrace = false)
      @collection[owner] << MethodInfo.new(method, owner, hook, access_controller: access_controller, backtrace: backtrace)
    end

    def merge!(method_catcher)
      method_catcher.collection.each do |owner, lst|
        @collection[owner] += lst
      end
      self
    end
  end
end
