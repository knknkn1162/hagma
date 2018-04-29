require 'hagma/const_info/collection'
require 'hagma/method_info/collection'

module Hagma
  # add core methods into MethodInfo.collection
  class Initializer
    def initialize
      @const_collection = ConstInfo::Collection.new
    end

    def enum
      @enum ||= @const_collection.enumerate
    end

    def method_collection
      collection = MethodInfo::Collection.new
      enum.class_modules.each do |const_info|
        collection.merge!(const_info.collect_methods)
      end
      collection
    end
  end
end
