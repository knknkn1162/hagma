require 'hagma'
require 'test_case/method_undefined_class'

RSpec.describe TestCase::MethodUndefinedClass do
  let(:klass) { TestCase::MethodUndefinedClass }
  let(:singleton) { klass.singleton_class }
  let!(:method_evs) { Hagma::MethodInfo.collection }
  let(:method_suites) do
    method_evs[kls].map { |m| [m.name, m.owner, m.hook] }
  end

  context 'when array size of method_suites' do
    it 'is 4' do
      expect(method_evs[klass].size).to eq 2
      expect(method_evs[singleton].size).to eq 2
    end
  end

  context 'when MethodRemovedClass#base_instance_method' do
    let(:kls) { klass }
    it 'belongs to Events.methods' do
      expect(method_suites).to include [:base_instance_method, klass, :method_undefined]
    end
  end

  context 'when MethodRemovedClass#base_singleton_method' do
    let(:kls) { singleton }
    it 'belongs to Events.methods' do
      expect(method_suites).to include [:base_singleton_method, singleton, :method_undefined]
    end
  end
end
