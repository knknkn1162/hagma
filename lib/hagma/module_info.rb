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
    attr_reader :mod, :owner, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(mod, owner, hook, backtrace = true)
      @mod = mod
      @owner = owner
      @hook = hook
      @backtrace_locations = Backtrace::Location.locations BACKTRACE_METHOD_NUMBER if backtrace
    end

    def push
      self.class.module_collection[chain_owner][position] << self
    end

    def position
      case hook
      when :included, :extended then
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
