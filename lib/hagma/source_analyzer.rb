module Hagma
  class SourceAnalyzer
    WINDOW_SIZE = 8
    attr_reader :absolute_path, :lineno
    def initialize(absolute_path, lineno)
      @absolute_path = absolute_path
      @lineno = lineno
    end

    def to_s
      lastno = lines.keys.max unless lines.empty?
      lines.map do |num, line|
        sign = num == lineno ? '=> ' : ' ' * 3
        format('%s%*d: %s', sign, lastno.to_s.size, num, line)
      end.join("\n")
    end

    private

    def lines(size = WINDOW_SIZE)
      @lines ||= begin
        File.open(file_path) do |file|
          res = {}
          file.each_line.each_with_index do |line, idx|
            if ((lineno - size)..(lineno + size)).cover?(idx + 1)
              res[idx + 1] = line
            end
          end
          res
        end
      end
    end
  end
end
