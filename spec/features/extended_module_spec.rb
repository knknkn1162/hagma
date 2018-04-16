require 'hagma'
require 'test_case/extended_module'

RSpec.describe TestCase::ExtendedModule do
  let(:mod) { TestCase::ExtendedModule }
  let(:base) { TestCase::BaseModule }
  let!(:method_evs) { Hagma::MethodInfo.method_collection }

  context 'when Hagma::Events::Summary#stat' do
    let(:base_instance_m) { method_evs[base].find { |m| m.name == :base_instance_method } }
    let(:extended_singleton_m) { method_evs[mod].find { |m| m.name == :extended_singleton_method } }
    let(:summary) { Hagma::Events::Summary.new method_evs, Hagma::ModuleInfo.module_collection }
    let(:stats) { summary.klass_stats mod }

    let(:base_instance_stat) { Hagma::Events::Summary::MethodStat.new(base_instance_m, mod, 0) }
    let(:extended_singleton_stat) { Hagma::Events::Summary::MethodStat.new(extended_singleton_m, mod, 0) }
    let(:stats) { summary.klass_stats mod }

    it 'is true when singleton_method' do
      #expect(stats[:singleton].keys).to eq %i[extended_singleton_method base_instance_method]
      expect(stats[:singleton][:base_instance_method]).to eq [base_instance_stat]
      #expect(stats[:singleton][:extended_singleton_method]).to eq [extended_singleton_stat]
    end
  end
end
