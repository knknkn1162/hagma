module Hagma
  class ModuleInfo
    attr_reader :mod, :owner, :hook
    def initialize(mod, owner, hook)
      @mod = mod
      @owner = owner
      @hook = hook
    end
  end
end
