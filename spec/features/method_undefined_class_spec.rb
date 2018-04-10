require 'hagma'
require 'test_case/method_undefined_class'

RSpec.describe TestCase::MethodUndefinedClass do
  let(:klass) { TestCase::MethodUndefinedClass }
  let!(:events) { Hagma::Events.method_collection }
  let(:method_suites) do
    events[klass].map { |m| [m.name, m.owner, m.hook] }
  end

  context 'when array size of method_suites' do
    it 'is 4' do
      expect(method_suites.size).to eq 4
    end
  end

  context 'when Object#method_undefined @ MethodUndefinedClass#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [:base_instance_method, klass, :method_undefined]
    end
  end

  context 'when BasicObject#singleton_method_undefined @ MethodUndefinedClass#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [:base_singleton_method, klass, :singleton_method_undefined]
    end
  end
end
