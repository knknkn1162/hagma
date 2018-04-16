require 'hagma'
require 'test_case/common_prepend_class'

RSpec.describe TestCase::CommonPrependClass do
  let(:mod) { TestCase::CommonPrependClass }
  let(:sub_mod) { TestCase::CommonModule }
  let!(:method_evs) { Hagma::MethodInfo.method_collection }

  context 'when Hagma::Events::Summary#stat' do
    let(:prepend_instance_m) { method_evs[mod].find { |m| m.name == :common_instance_method } }
    let(:instance_m) { method_evs[sub_mod].find { |m| m.name == :common_instance_method } }

    let(:summary) { Hagma::Events::Summary.new method_evs, Hagma::ModuleInfo.module_collection }
    let(:stats) { summary.klass_stats mod }

    let(:prepend_instance_stat) { Hagma::Events::Summary::MethodStat.new(prepend_instance_m, mod, 0) }
    let(:instance_stat) { Hagma::Events::Summary::MethodStat.new(instance_m, sub_mod, -1) }

    it 'is true when singleton_method' do
      expect(stats[:instance][:common_instance_method]).to eq [instance_stat, prepend_instance_stat]
    end
  end
end
