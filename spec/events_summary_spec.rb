require 'hagma/events/summary'
require 'hagma/module_info'
require 'hagma/method_info'

module TestCase
  class Sample; end
  class Other; end
  module SampleModule; end
end

RSpec.describe Hagma::Events::Summary do
  let(:owner) { TestCase::Sample }
  let(:other_owner) { TestCase::Other }
  let(:mod) { TestCase::SampleModule }
  # method
  let(:instance_method1_info) { Hagma::MethodInfo.new(:instance_method1, owner, :method_added) }
  let(:instance_method2_info) { Hagma::MethodInfo.new(:instance_method2, other_owner, :method_added) }
  let(:singleton_method1_info) { Hagma::MethodInfo.new(:singleton_method1, owner, :singleton_method_added) }
  let(:singleton_method2_info) { Hagma::MethodInfo.new(:singleton_method2, other_owner, :singleton_method_added) }
  let(:module_instance_method_info) { Hagma::MethodInfo.new(:module_instance_method, mod, :method_added) }
  let(:module_function_info) { Hagma::MethodInfo.new(:module_function, mod, :singleton_method_added) }

  # module
  let(:included_module1_info) { Hagma::ModuleInfo.new(:included_module1, owner, :included) }
  let(:included_module2_info) { Hagma::ModuleInfo.new(:included_module2, other_owner, :included) }
  let(:extended_module1_info) { Hagma::ModuleInfo.new(:extended_module1, owner, :extended) }
  let(:extended_module2_info) { Hagma::ModuleInfo.new(:extended_module2, other_owner, :extended) }
  let(:prepended_module1_info) { Hagma::ModuleInfo.new(:prepended_module1, other_owner, :prepended) }
  let(:prepended_module2_info) { Hagma::ModuleInfo.new(:prepended_module2, other_owner, :prepended) }

  let(:method_collection) do
    {
      owner => [instance_method1_info, singleton_method1_info],
      other_owner => [instance_method2_info, singleton_method2_info],
      mod => [module_instance_method_info, module_function_info]
    }
  end

  let(:module_collection) do
    {
      owner => [included_module1_info, extended_module1_info, prepended_module1_info],
      other_owner => [included_module2_info, extended_module2_info, prepended_module2_info]
    }
  end

  let!(:klass) { Hagma::Events::Summary }
end
