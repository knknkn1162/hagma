require 'hagma/method_info'
require 'test_case/base_class'

RSpec.describe Hagma::MethodInfo do
  describe 'when test_case/base_class' do
    let(:method_info) { Hagma::MethodInfo.new(met, owner, hook, backtrace) }

    # default
    let(:met) { :base_instance_method }
    let(:owner) { TestCase::BaseClass }
    let(:hook) { :method_added }
    let(:backtrace) { false }

    context 'when accessors in Hagma::MethodInfo' do
      it 'can be accessed by dot operator' do
        expect([method_info.name, method_info.owner, method_info.hook]).to eq [met, owner, hook]
      end
    end

    context 'when method_type' do
      it 'is instance method' do
        expect(method_info.method_type).to eq :instance
      end
    end

    context 'when singleton?' do
      it 'is false' do
        expect(method_info.singleton?).to eq false
      end
    end

    context 'when instance?' do
      it 'is true' do
        expect(method_info.instance?).to eq true
      end
    end

    context 'when find_method' do
      let(:unbound_method) { method_info.find_method }
      it 'is Unbounded class' do
        expect(unbound_method).to be_instance_of(UnboundMethod)
      end

      it 'is correct owner and name' do
        expect([unbound_method.owner, unbound_method.name]).to eq [owner, met]
      end
    end
  end
end
