require 'hagma'
require 'test_case/base_inherited'

RSpec.describe TestCase::BaseInherited do
  # evaluate only once
  let(:inherited_klass) { TestCase::BaseInherited }
  let(:super_klass) { TestCase::SuperClass }
  let!(:method_evs) { Hagma::MethodInfo.method_collection }
  let(:method_suites) do
    method_evs[inherited_klass].map { |m| [m.owner, m.name, m.hook] }
  end

  context 'when Hagma::Events::Summary#stat' do
    let(:inherited_instance_m) { method_evs[inherited_klass].find { |m| m.name == :common_instance_method } }
    let(:inherited_singleton_m) { method_evs[inherited_klass].find { |m| m.name == :common_singleton_method } }
    let(:super_instance_m) { method_evs[super_klass].find { |m| m.name == :common_instance_method } }
    let(:super_singleton_m) { method_evs[super_klass].find { |m| m.name == :common_singleton_method } }

    let(:summary) { Hagma::Events::Summary.new Hagma::MethodInfo.method_collection, Hagma::ModuleInfo.module_collection }
    let(:stats) { summary.klass_stats inherited_klass }

    let(:instance_stats) do
      [Hagma::Events::Summary::MethodStat.new(inherited_instance_m, inherited_klass, 0),
       Hagma::Events::Summary::MethodStat.new(super_instance_m, super_klass, 1)]
    end

    let(:singleton_stats) do
      [Hagma::Events::Summary::MethodStat.new(inherited_singleton_m, inherited_klass, 0),
       Hagma::Events::Summary::MethodStat.new(super_singleton_m, super_klass, 1)]
    end

    it 'is true when instance_method' do
      expect(stats[:instance].keys).to eq %i[common_instance_method singleton_method_added singleton_method_removed singleton_method_undefined]
      expect(stats[:instance][:common_instance_method]).to eq instance_stats
    end

    it 'is true when singleton_method' do
      expect(stats[:singleton].keys).to eq %i[common_singleton_method]
      expect(stats[:singleton][:common_singleton_method]).to eq singleton_stats
    end
  end
end
