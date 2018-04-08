require 'hagma/extractor'

RSpec.describe Hagma::Extractor do
  let(:absolute_path) { 'dummy.rb' }
  let(:script) do
    (1..10).map(&:to_s)
  end
  let(:lineno) { 5 }
  let(:extractor) { Hagma::Extractor.new(absolute_path, lineno) }

  context 'when #extract_lines and the window size is 4' do
    let(:size) { 4 }
    context 'when current line number is 2' do
      let(:lineno) { 2 }
      it 'ranges from line.0 to line.6' do
        res = (1..7).map { |i| [i - 1, i.to_s] }.to_h # [1,2,3,4,5,6,7]
        expect(extractor.__send__(:extract_lines, script, 4)).to eq res
      end
    end

    context 'when current line number is 6' do
      let(:lineno) { 7 }
      it 'ranges from line.3 to line.9' do
        res = (4..10).map { |i| [i - 1, i.to_s] }.to_h
        expect(extractor.__send__(:extract_lines, script, 4)).to eq res
      end
    end
  end

  context 'when #to_s' do
    context 'when file is not found' do
      let(:extractor) do
        Hagma::Extractor.new(absolute_path, lineno) do
          raise IOError
        end
      end

      it 'returns the string type of exception' do
        expect(extractor.to_s).to start_with 'IOError'
      end
    end
  end
end