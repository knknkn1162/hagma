require 'hagma'
require 'test_case/base_extend_module'

RSpec.describe TestCase::BaseExtendModule do
  let(:mod) { TestCase::BaseExtendModule }
  let(:sub_mod) { TestCase::ExtendedModule }
  let!(:method_evs) { Hagma::MethodInfo.method_collection }

  context 'when Hagma::Events::Summary#stat' do
    let(:base_singleton_m) { method_evs[mod].find { |m| m.name == :base_singleton_method } }
    let(:extended_instance_m) { method_evs[sub_mod].find { |m| m.name == :extended_instance_method } }
    let(:summary) { Hagma::Events::Summary.new method_evs, Hagma::ModuleInfo.module_collection }
    let(:stats) { summary.klass_stats mod }

    let(:base_singleton_stat) { Hagma::Events::Summary::MethodStat.new(base_singleton_m, mod, 0) }
    let(:extended_instance_stat) { Hagma::Events::Summary::MethodStat.new(extended_instance_m, mod, 0) }
    let(:stats) { summary.klass_stats mod }

    it 'is true when singleton_method' do
      expect(stats[:singleton].keys).to eq %i[base_singleton_method extended_instance_method]
      expect(stats[:singleton][:base_singleton_method]).to eq [base_singleton_stat]
      expect(stats[:singleton][:extended_instance_method]).to eq [extended_instance_stat]
    end
  end
end
