require 'hagma/module_info'

module Hagma
  # Class for collecting method
  class ModuleCatcher
    def initialize
      @collection ||= Hash.new { |h, k| h[k] = { backward: [], forward: [], leftmost: [] } }
    end

    def push(mod, owner, hook)
      module_info = ModuleInfo.new(mod, owner, hook)
      @collection[module_info.chain_owner][module_info.position] << module_info
    end
  end
end
