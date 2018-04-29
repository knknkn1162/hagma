require 'hagma/method_catcher'

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
      [const, const.singleton_class].each do |cst|
        %i[public protected private].each do |controller|
          cst.__send__("#{controller}_instance_methods", false).map do |met|
            MethodCatcher.push(met, cst, :core, access_controller: controller, backtrace: false)
          end
        end
      end
    end
  end
end
