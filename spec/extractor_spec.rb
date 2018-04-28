require 'hagma/extractor'

RSpec.describe Hagma::Extractor do
  describe '#extract_lines' do
    let(:size) { 4 }
    let(:absolute_path) { 'dummy.rb' }
    let(:extractor) { Hagma::Extractor.new(absolute_path, lineno) }

    subject do
      script = (1..10).map(&:to_s)
      extractor.__send__(:extract_lines, script, size)
    end

    context 'when #extract_lines and the window size is 4' do
      context 'when current line number is 2' do
        let(:lineno) { 2 }
        it 'ranges from line.1 to line.6' do
          res = (1..(lineno + size)).map { |i| [i - 1, i.to_s] }.to_h # [1,2,3,4,5,6]
          is_expected.to eq res
        end
      end

      context 'when current line number is 6' do
        let(:lineno) { 7 }
        it 'ranges from line2. to line.10' do
          res = ((lineno - size)..10).map { |i| [i - 1, i.to_s] }.to_h # [3,4,5,6,7,8,9,10]
          is_expected.to eq res
        end
      end
    end
  end

  context 'when #to_s' do
    context 'when invalid formatter' do
      let(:absolute_path) { __FILE__ }
      let(:lineno) { __LINE__ + 3 } # the line, `raise IOError`
      let(:extractor) do
        Hagma::Extractor.new(absolute_path, lineno) do
          raise IOError
        end
      end
      subject { extractor.to_s }

      it 'returns the string type of exception' do
        is_expected.to start_with 'IOError'
        is_expected.to include "#{absolute_path}:#{lineno}"
      end
    end
  end
end
