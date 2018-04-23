require 'hagma/method_info'
require 'hagma/const_catcher'

module Hagma
  # add core methods into MethodInfo.method_collection
  module Init
    ConstCatcher.new.enumerate.class_modules.each do |const_info|
      MethodInfo.method_collection.merge!(const_info.collect_methods)
    end
  end
end
