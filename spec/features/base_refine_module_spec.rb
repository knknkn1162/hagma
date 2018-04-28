require 'hagma'
require 'test_case/base_refine_module'

RSpec.describe TestCase::BaseRefinementModule do
  # evaluate only once
  let!(:method_evs) { Hagma::MethodInfo.method_collection }
  let!(:module_evs) { Hagma::ModuleInfo.module_collection[owner][:leftmost] }
  let!(:refinement_module_info) do
    module_evs.find { |module_info| module_info.hook == :refined }
  end
  let(:mod) { refinement_module_info.target }
  let(:owner) { TestCase::BaseRefinedClass }

  context 'when array size of refinement methods' do
    it 'is 1' do
      expect(method_evs.keys).to include mod
      expect(method_evs[mod].size).to eq 1
    end
  end

  context 'when method_collection has :base_instance_method in the right way' do
    let(:method_info) { method_evs[mod][0] }
    it 'belongs to Events.methods' do
      expect([method_info.name, method_info.owner, method_info.hook]).to eq [:base_instance_method, mod, :method_added]
    end
  end

  context 'when module_collection has refiment module in the right way' do
    let(:module_info) { module_evs[0] }
    it 'belongs to Events.methods' do
      expect([module_info.target, module_info.owner, module_info.hook]).to eq [mod, owner, :refined]
    end
  end
end
