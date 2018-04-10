require 'hagma'
require 'test_case/method_removed_class'

RSpec.describe TestCase::MethodRemovedClass do
  let(:klass) { TestCase::MethodRemovedClass }
  let!(:events) { Hagma::Events.method_collection }
  let(:method_suites) do
    events[klass].map { |m| [m.name, m.owner, m.hook] }
  end

  context 'when Object#method_removed @ MethodRemovedClass#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [:base_instance_method, klass, :method_removed]
    end
  end

  context 'when BasicObject#singleton_method_removed @ MethodRemovedClass#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [:base_singleton_method, klass, :singleton_method_removed]
    end
  end
end
