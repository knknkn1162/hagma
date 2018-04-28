module Hagma
  module Events
    # @param method_info [MethodInfo]
    # @param owner ModuleInfo The ancestor that the method has.
    # @param level Integer
    class MethodStat
      attr_reader :method_info, :owner, :level
      def initialize(method_info, owner, hook)
        @method_info = method_info
        @owner = owner
        @hook = hook
      end
    end
  end
end
