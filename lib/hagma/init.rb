require 'hagma/method_info'
require 'hagma/const_catcher'

module Hagma
  # add core methods into MethodInfo.collection
  module Init
    ConstCatcher.new.enumerate.class_modules.each do |const_info|
      MethodInfo.collection.merge!(const_info.collect_methods)
    end
  end
end
