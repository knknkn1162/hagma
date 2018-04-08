require 'hagma'
require 'test_case/base_extended'

RSpec.describe TestCase::BaseExtended do
  let(:owner) { TestCase::BaseExtended }
  let!(:events) { Hagma::Events.module_collection }
  let(:method_suites) do
    events[owner].map { |m| [m.mod, m.owner, m.hook] }
  end
  context 'when Module#extended @ BaseExtend module' do
    it 'belongs to Events.module_collection' do
      expect(method_suites).to include [TestCase::BaseModule, owner, :extended]
    end
  end
end
