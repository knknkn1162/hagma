require 'hagma'
require 'test_case/base_class'

RSpec.describe TestCase::BaseClass do
  # evaluate only once
  let!(:events) { Hagma::Events.methods }
  let(:method_suites) do
    events.map { |m| [m.owner, m.name, m.hook] }
  end

  context 'when Object#method_added @ BaseClass#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [TestCase::BaseClass, :base_instance_method, :method_added]
    end
  end

  context 'when Object#singleton_method_added @ BaseClass#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [TestCase::BaseClass, :base_singleton_method, :singleton_method_added]
    end
  end

  context 'when Hagma::MethodInfo#analyze method' do
    let(:method_info) do
      events.find do |m|
        [m.owner, m.name, m.hook] == [TestCase::BaseClass, :base_singleton_method, :singleton_method_added]
      end
    end
    it 'coincides source_location & head of caller_locations' do
      method_info.analyze
      source_location = method_info.instance_variable_get(:@location)
      caller_location = method_info.instance_variable_get(:@backtrace_locations)[0]
      expect([source_location.absolute_path, source_location.lineno]).to eq [caller_location.absolute_path, caller_location.lineno]
    end
  end
end
