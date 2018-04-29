require 'hagma/location'

module Hagma
  module Backtrace
    # parser class for Thread::Backtrace::Location
    class Location
      class << self
        def split(location)
          location.class.instance_methods(false).map do |sym|
            [sym, location.__send__(sym)]
          end.to_h
        end

        def locations(start)
          caller_locations(start).map do |loc|
            Hagma::Location.new(**split(loc))
          end
        end
      end
    end
  end
end
