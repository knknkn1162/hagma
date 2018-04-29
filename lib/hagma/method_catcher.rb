require 'hagma/method_info'

module Hagma
  # Class for collecting method
  class MethodCatcher
    class << self
      def collection
        @collection ||= Hash.new { |h, k| h[k] = [] }
      end

      def push(method, owner, hook, access_controller = nil, backtrace = false)
        collection[owner] << MethodInfo.new(method, owner, hook, access_controller: access_controller, backtrace: backtrace)
      end
    end
  end
end
