require 'hagma/method_info'
require 'test_case/base_class'

RSpec.describe Hagma::MethodInfo do
  describe 'when test_case/base_class' do
    let(:method_info) { Hagma::MethodInfo.new(met, owner, hook, backtrace: false) }

    # default
    let(:met) { :base_instance_method }
    let(:owner) { TestCase::BaseClass }
    let(:hook) { :method_added }

    context 'when accessors in Hagma::MethodInfo' do
      it 'can be accessed by dot operator' do
        expect([method_info.name, method_info.owner, method_info.hook]).to eq [met, owner, hook]
      end
    end

    context 'when #method_type' do
      subject { method_info.method_type }
      context 'when instance method' do
        it { is_expected.to eq :instance }
      end

      context 'when singleton method' do
        let(:hook) { :singleton_method_added }
        it { is_expected.to eq :singleton }
      end

      context 'when otherwise' do
        let(:hook) { :singleton_dummy_added }
        it { is_expected.to eq nil }
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
