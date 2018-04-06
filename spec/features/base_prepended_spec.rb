require 'hagma'
require 'test_case/base_prepended'

RSpec.describe TestCase::BasePrepended do
  let!(:events) { Hagma::Events.modules }
  let(:method_suites) do
    events.map { |m| [m.mod, m.owner, m.hook] }
  end
  context 'when Module#prepended @ BaseExtend module' do
    it 'belongs to Events.modules' do
      expect(method_suites).to include [TestCase::BaseModule, TestCase::BasePrepended, :prepended]
    end
  end
end
