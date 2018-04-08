module Hagma
  # store information on the designated module
  class ModuleInfo
    attr_reader :mod, :owner, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(mod, owner, hook)
      @mod = mod
      @owner = owner
      @hook = hook
      # backtrace if block is given, or return nil
      # this lets us test this class easily
      @backtrace_locations = yield BACKTRACE_METHOD_NUMBER if block_given?
    end
  end
end
