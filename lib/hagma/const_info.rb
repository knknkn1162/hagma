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
      res ||= Hash.new { |h, k| h[k] = [] }
      [const, const.singleton_class].each do |cst|
        %i[public protected private].each do |controller|
          cst.__send__("#{controller}_instance_methods", false).map do |met|
            res[cst] << MethodInfo.new(met, cst, :core, access_controller: controller, backtrace: false)
          end
        end
      end
      res
    end
  end
end
