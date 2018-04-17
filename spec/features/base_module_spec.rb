require 'hagma'
require 'test_case/base_module'

RSpec.describe TestCase::BaseModule do
  # evaluate only once
  let(:klass) { TestCase::BaseModule }
  let(:singleton) { klass.singleton_class }
  let!(:method_evs) { Hagma::MethodInfo.method_collection }
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
  context 'when Hagma::Events::Summary#stat' do
    let(:instance_m) { method_evs[mod].find { |m| m.name == :base_instance_method } }
    let(:singleton_m) { method_evs[mod].find { |m| m.name == :base_singleton_method } }
    let(:summary) { Hagma::Events::Summary.new Hagma::MethodInfo.method_collection, Hagma::ModuleInfo.module_collection }
    let(:stats) { summary.klass_stats mod }

    let(:instance_stat) { Hagma::Events::Summary::MethodStat.new(instance_m, mod, 0) }
    let(:singleton_stat) { Hagma::Events::Summary::MethodStat.new(singleton_m, mod, 0) }

    it 'is true when instance_method' do
      expect(stats[:instance].keys).to eq %i[base_instance_method]
      expect(stats[:instance][:base_instance_method]).to eq [instance_stat]
    end

    it 'is true when singleton_method' do
      expect(stats[:singleton].keys).to eq %i[base_singleton_method]
      expect(stats[:singleton][:base_singleton_method]).to eq [singleton_stat]
    end
  end
end
