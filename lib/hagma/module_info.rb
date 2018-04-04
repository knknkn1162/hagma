module Hagma
  class ModuleInfo
    attr_reader :mod, :owner, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(mod, owner, hook, backtrace = true)
      @mod = mod
      @owner = owner
      @hook = hook
      # trace before Hagma::Hook::module_event
      @backtrace_locations = Backtrace::Location.locations(BACKTRACE_METHOD_NUMBER) if backtrace
    end
  end
end
