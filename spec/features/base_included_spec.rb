require 'hagma'
require 'test_case/base_included'

RSpec.describe TestCase::BaseIncluded do
  let!(:events) { Hagma::Events.modules }
  let(:method_suites) do
    events.map { |m| [m.mod, m.owner, m.hook] }
  end
  context 'when Module#included @ BaseIncluded module' do
    it 'belongs to Events.modules' do
      expect(method_suites).to include [TestCase::BaseModule, TestCase::BaseIncluded, :included]
    end
  end
end
