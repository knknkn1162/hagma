module Hagma
  # store information on the designated module
  class ModuleInfo
    attr_reader :mod, :owner, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(mod, owner, hook)
      @mod = mod
      @owner = owner
      @hook = hook
      # trace before Hagma::Hook::module_event
      @backtrace_locations = Backtrace::Location.locations(BACKTRACE_METHOD_NUMBER)
    end
  end
end
