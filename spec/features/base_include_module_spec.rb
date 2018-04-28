require 'hagma'
require 'test_case/base_include_module'

RSpec.describe TestCase::BaseIncludeClass do
  # evaluate only once
  let!(:module_evs) { Hagma::ModuleInfo.collection[owner][:forward] }
  let!(:module_info) do
    module_evs.find { |module_info| module_info.target == mod }
  end
  let(:mod) { TestCase::BaseIncludedModule }
  let(:owner) { TestCase::BaseIncludeClass }

  context 'when collection has refiment module in the right way' do
    it 'belongs to Events.methods' do
      expect([module_info.target, module_info.owner, module_info.hook]).to eq [mod, owner, :included]
    end
  end
end
