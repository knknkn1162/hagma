require 'hagma'
require 'test_case/base_class'

RSpec.describe TestCase::BaseClass do
  # evaluate only once
  let(:klass) { TestCase::BaseClass }
  let(:singleton) { klass.singleton_class }
  let!(:method_evs) { Hagma::MethodInfo.collection }
  let(:method_suites) { [method_info.owner, method_info.name, method_info.hook] }

  context 'when array size of method_suites' do
    it 'is 2' do
      expect(method_evs.keys).to include klass, singleton
      expect(method_evs[klass].size).to eq 1
      expect(method_evs[singleton].size).to eq 1
    end
  end

  context 'when BaseClass#base_instance_method' do
    let(:method_info) { method_evs[klass][0] }
    it 'belongs to Events.methods' do
      expect(method_suites).to eq [klass, :base_instance_method, :method_added]
    end
  end

  context 'when BaseClass::base_singleton_method' do
    let(:method_info) { method_evs[singleton][0] }
    it 'belongs to Events.methods' do
      expect(method_suites).to eq [singleton, :base_singleton_method, :method_added]
    end
  end

  context 'when Hagma::MethodInfo#analyze method' do
    let(:method_info) do
      method_evs[singleton].find do |m|
        [m.owner, m.name, m.hook] == [singleton, :base_singleton_method, :method_added]
      end
    end
    it 'coincides source_location & head of caller_locations' do
      method_info.analyze
      source_location = method_info.instance_variable_get(:@location)
      caller_location = method_info.instance_variable_get(:@backtrace_locations)[0]
      expect([source_location.absolute_path, source_location.lineno]).to eq [caller_location.absolute_path, caller_location.lineno]
    end
  end
end
