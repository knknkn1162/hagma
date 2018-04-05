require 'hagma'
require 'test_case/base_class'

RSpec.describe TestCase::BaseClass do
  # evaluate only once
  let!(:events) { Hagma::Events.methods }
  let(:method_suites) do
    events.map { |m| [m.klass, m.name, m.hook] }
  end

  context 'when Object#method_added @ BaseClass#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [TestCase::BaseClass, :base_instance_method, :method_added]
    end
  end

  context 'when Object#singleton_method_added @ BaseClass#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [TestCase::BaseClass, :base_singleton_method, :singleton_method_added]
    end
  end
end
