require 'hagma'
require 'test_case/base_extended'

RSpec.describe TestCase::BaseExtended do
  let!(:events) { Hagma::Events.modules }
  let(:method_suites) do
    events.map { |m| [m.mod, m.owner, m.hook] }
  end
  context 'when Module#extended @ BaseExtend module' do
    it 'belongs to Events.modules' do
      expect(method_suites).to include [TestCase::BaseModule, TestCase::BaseExtended, :extended]
    end
  end
end
