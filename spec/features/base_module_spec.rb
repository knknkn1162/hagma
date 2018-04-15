require 'hagma'
require 'test_case/base_module'

RSpec.describe TestCase::BaseModule do
  # evaluate only once
  let(:mod) { TestCase::BaseModule }
  let!(:method_evs) { Hagma::MethodInfo.method_collection }
  let(:method_suites) do
    method_evs[mod].map { |m| [m.owner, m.name, m.hook] }
  end

  context 'when array size of method_suites' do
    it 'is 2' do
      expect(method_suites.size).to eq 2
    end
  end

  context 'when Object#method_added @ BaseModule#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [mod, :base_instance_method, :method_added]
    end
  end

  context 'when Object#singleton_method_added @ BaseModule#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [mod, :base_singleton_method, :singleton_method_added]
    end
  end

  context 'when Hagma::MethodInfo#analyze method' do
    let(:method_info) do
      method_evs[mod].find do |m|
        [m.owner, m.name, m.hook] == [mod, :base_singleton_method, :singleton_method_added]
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
