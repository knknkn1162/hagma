module Hagma
  # store information on the designated module
  class ModuleInfo
    class << self
      def module_collection
        @module_collection ||= Hash.new { |h, k| h[k] = [] }
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
      self.class.module_collection[owner] << self
    end
  end
end
