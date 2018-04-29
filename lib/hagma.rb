require 'hagma/hook'
# store existed method, e.g) Object#taint..
require 'hagma/initializer'
initializer = Hagma::Initializer.new
Hagma::Events.method_collection.merge!(initializer.method_collection)

require 'hagma/core_ext/hook'
