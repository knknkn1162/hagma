require 'hagma/method_info/collection'

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
      collection = MethodInfo::Collection.new
      [const, const.singleton_class].each do |cst|
        %i[public protected private].each do |controller|
          cst.__send__("#{controller}_instance_methods", false).map do |met|
            collection.push(met, cst, :core, controller)
          end
        end
      end
      collection
    end
  end
end
