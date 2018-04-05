require 'hagma'
require_relative '../test_case/base_class'

RSpec.describe Hagma::TestCase::BaseClass do
  # evaluate only once
  let!(:methods) do
    Hagma::Events.methods.map { |m| [m.klass, m.name, m.hook] }
  end

  context 'when BaseClass#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(methods).to include [Hagma::TestCase::BaseClass, :base_instance_method, :method_added]
    end
  end

  context 'when BaseClass#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(methods).to include [Hagma::TestCase::BaseClass, :base_singleton_method, :singleton_method_added]
    end
  end
end
