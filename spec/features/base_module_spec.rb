require 'hagma'
require 'test_case/base_module'

RSpec.describe TestCase::BaseModule do
  # evaluate only once
  let(:mod) { TestCase::BaseModule }
  let!(:events) { Hagma::Events.method_collection }
  let(:method_suites) do
    events[mod].map { |m| [m.owner, m.name, m.hook] }
  end

  context 'when Object#method_added @ BaseModule#base_instance_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [mod, :base_instance_method, :method_added]
    end
  end

  context 'when Object#singleton_method_added @ BaseModule#base_singleton_method' do
    it 'belongs to Events.methods' do
      expect(method_suites).to include [mod, :base_singleton_method, :singleton_method_added]
    end
  end

  context 'when Hagma::MethodInfo#analyze method' do
    let(:method_info) do
      events[mod].find do |m|
        [m.owner, m.name, m.hook] == [mod, :base_singleton_method, :singleton_method_added]
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
