module Hagma
  # store information on the designated module
  class ModuleInfo
    class << self
      def module_collection
        @module_collection ||= Hash.new { |h, k| h[k] = { backward: [], forward: [] } }
      end

      def chain(owner)
        @chain ||= {}
        @chain[owner] ||= module_collection[owner][:backward].reverse + [dummy] + module_collection[owner][:forward].reverse
      end

      def _linked_ancestors(target_info)
        chain(target_info.target).map do |ancestor_module_info|
          if ancestor_module_info.target.nil?
            target_info
          else
            _linked_ancestors ancestor_module_info
          end
        end
      end

      def linked_ancestors(owner)
        _linked_ancestors(root(owner))
      end

      # @return [List[ModuleInfo]] get ancestors which element is ModuleInfo. To get the normal ancestors, exec ModuleInfo.ancestors(owner).map(&:owner).
      def ancestors(owner)
        @ancestors ||= {}
        res = linked_ancestors(owner).flatten
        @ancestors[owner] ||= res + res.last.target.ancestors[1..-1].map { |klass| new(klass, nil, nil) }
      end

      def root(owner)
        new(owner, nil, nil, false)
      end

      def dummy
        @dummy ||= new(nil, nil, nil, false)
      end
    end
    attr_reader :target, :owner, :hook
    BACKTRACE_METHOD_NUMBER = 5
    def initialize(target, owner, hook, backtrace = true)
      @target = target
      @owner = owner
      @hook = hook
      @backtrace_locations = Backtrace::Location.locations BACKTRACE_METHOD_NUMBER if backtrace
    end

    def push
      self.class.module_collection[chain_owner][position] << self
    end

    def position
      case hook
      when :included, :extended, :inherited then
        :forward
      when :prepended then
        :backward
      end
    end

    def chain_owner
      hook == :extended ? owner.singleton_class : owner
    end
  end
end
