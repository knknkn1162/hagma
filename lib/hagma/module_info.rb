module Hagma
  # store information on the designated module
  class ModuleInfo
    class << self
      def module_collection
        @module_collection ||= Hash.new { |h, k| h[k] = { backward: [], forward: [] } }
      end

      def chain owner
        @chain ||= {}
        @chain[owner] ||= module_collection[owner][:backward].reverse + [new(nil, owner, nil)] + module_collection[owner][:forward].reverse
      end
    end
    attr_reader :target, :owner, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(target, owner, hook, backtrace = true)
      @target = target
      @owner = owner
      @hook = hook
      @backtrace_locations = Backtrace::Location.locations BACKTRACE_METHOD_NUMBER if backtrace
    end

    def push
      self.class.module_collection[chain_owner][position] << self
    end

    def position
      case hook
      when :included, :extended, :inherited then
        :forward
      when :prepended then
        :backward
      end
    end

    def chain_owner
      hook == :extended ? owner.singleton_class : owner
    end
  end
end
