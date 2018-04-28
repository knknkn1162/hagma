module Hagma
  module Events
    # @param method_info [MethodInfo]
    # @param owner ModuleInfo The ancestor that the method has.
    # @param level Integer
    class MethodStat
      attr_reader :method_info, :owner, :level
      def initialize(method_info, module_info, level)
        @method_info = method_info
        @owner = module_info
        @level = level
      end

      def method_backtraces
        method_info.backtrace_locations
      end

      def module_backtraces
        module_info.backtrace_locations
      end
    end
  end
end
