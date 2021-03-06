module Hagma
  # store information on the designated module
  class ModuleInfo
    class << self
      def root(owner)
        new(owner, nil, nil, false)
      end

      def dummy
        @dummy ||= new(nil, nil, nil, false)
      end
    end

    attr_reader :target, :owner, :hook, :backtrace_locations
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(target, owner, hook, backtrace)
      @target = target
      @owner = owner
      @hook = hook
      @backtrace_locations = Backtrace::Location.locations BACKTRACE_METHOD_NUMBER if backtrace
    end

    def position
      case hook
      when :included, :extended, :inherited then
        :forward
      when :prepended then
        :backward
      when :refined then
        :leftmost
      end
    end

    def chain_owner
      hook == :extended ? owner.singleton_class : owner
    end
  end
end
