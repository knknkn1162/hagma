require 'hagma'
require 'test_case/base_prepended_class'

RSpec.describe TestCase::BasePrependedClass do
  let(:owner) { TestCase::BasePrependedClass }
  let!(:events) { Hagma::ModuleInfo.module_collection }
  let(:method_suites) do
    events[owner].map { |m| [m.mod, m.owner, m.hook] }
  end

  context 'when array size of method_suites' do
    it 'is 1' do
      expect(method_suites.size).to eq 1
    end
  end

  context 'when Module#prepended @ BasePrependedClass' do
    it 'belongs to ModuleInfo.module_collection' do
      expect(method_suites).to include [TestCase::BaseModule, owner, :prepended]
    end
  end
end