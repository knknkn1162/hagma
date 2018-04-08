require 'hagma'
require 'test_case/base_included'

RSpec.describe TestCase::BaseIncluded do
  let(:owner) { TestCase::BaseIncluded }
  let!(:events) { Hagma::Events.module_collection }
  let(:method_suites) do
    events[owner].map { |m| [m.mod, m.owner, m.hook] }
  end
  context 'when Module#included @ BaseIncluded module' do
    it 'belongs to Events.module_collection' do
      expect(method_suites).to include [TestCase::BaseModule, owner, :included]
    end
  end
end
