module Hagma
  class Location
    def initialize(**args)
      @absolute_path = args[:absolute_path]
      @base_label = args[:base_label]
      @label = args[:label]
      @lineno = args[:lineno]
    end
  end
end
