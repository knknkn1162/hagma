require 'hagma/method_info'

module Hagma
  class ConstInfo
    attr_reader :symbol, :const, :owner, :depth
    def initialize(symbol, const, owner, depth)
      @symbol = symbol
      @const = const
      @owner = owner
      @depth = depth
    end

    def collect_methods
      res = []
      [const, const.singleton_class].map do |cst|
        cst.instance_methods(false).map do |met|
          res << MethodInfo.new(met, cst, :core, false)
        end
      end
      res
    end
  end
end
