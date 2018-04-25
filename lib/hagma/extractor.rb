module Hagma
  # analyze  from files
  class Extractor
    WINDOW_SIZE = 8
    attr_reader :absolute_path, :lineno

    class << self
      def full_lines(path)
        @path_lines ||= Hash.new
        @path_lines[path] ||= File.read(path).split("\n")
      end

      # Format the extracted lines by default. You can customize the fomatter in initialization.
      def format(lines, cur_no)
        lastno = lines.keys.max
        lines.map do |num, line|
          sign = num + 1 == cur_no ? '=> ' : ' ' * 3
          super('%s%*d: %s', sign, lastno.to_s.size, num + 1, line)
        end.join("\n")
      end
    end

    # @param absolute_path [String] absolute path
    # @param lineno [Integer] lineno
    # @param block [Proc] formatter which requires lines and current lineno and returns string.
    def initialize(absolute_path, lineno, &block)
      @absolute_path = absolute_path
      @lineno = lineno
      @formatter = block
    end

    # @return [String] The part of codes with lineno and current line arrow. If an exception occurs, backtrace is returned with String.
    def to_s
      begin
        @formatter ? @formatter.call(lines, lineno) : self.class.format(lines, lineno)
      rescue => e
        [e.exception, e.backtrace].flatten.join("\n")
      end
    end

    # @return [Hash] hash from lineno to String
    def lines(size = WINDOW_SIZE)
      @lines ||= extract_lines self.class.full_lines(absolute_path), size
    end

    private

    def extract_lines(lines, size)
      startno = [lineno - 1 - size, 0].max
      lines[startno..(lineno - 1 + size)].map.with_index(startno) { |line, idx| [idx, line] }.to_h
    end
  end
end
