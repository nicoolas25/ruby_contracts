module Contracts
  module DSL
    def self.included(base)
      if ENV['ENABLE_ASSERTION']
        base.extend Contracts::DSL::ClassMethods
        base.__contracts_initialize
      else
        base.extend Contracts::DSL::EmptyClassMethods
      end
    end

    def implies(arg1, arg2)
      ! arg1 || arg2
    end

    module ClassMethods
      def inherited(subclass)
        super
        subclass.__contracts_initialize
      end

      def __contracts_initialize
        @__contracts = Contracts::List.new
        @__contracts_for = {}
      end

      def __contracts_for(name, current_contracts=nil)
        if @__contracts_for.has_key?(name) && !current_contracts
          @__contracts_for[name]
        else
          contracts = ancestors[1..-1].reverse.reduce([]) do |c, klass|
            ancestor_hash = klass.instance_variable_get('@__contracts_for')
            c += ancestor_hash[name] if ancestor_hash && ancestor_hash.has_key?(name)
            c
          end
          contracts << current_contracts if current_contracts
          @__contracts_for[name] = contracts
        end
      end

      def __contract_failure!(name, message, result, *args)
        args.pop if args.last.kind_of?(Proc)
        raise Contracts::Error.new("#{self}##{name}(#{args.join ', '}) => #{result || "?"} ; #{message}.")
      end

      def type(options)
        @__contracts << Contracts::InputType.new(options[:in].kind_of?(Array) ? options[:in] : [options[:in]])   if options.has_key?(:in)
        @__contracts << Contracts::OutputType.new(options[:out]) if options.has_key?(:out)
      end

      def pre(message=nil, &block)
        @__contracts << Contracts::Precondition.new(message, block)
      end

      def post(message=nil, &block)
        @__contracts << Contracts::Postcondition.new(message, block)
      end

      def method_added(name)
        super

        return if @__skip_other_contracts_definitions

        __contracts = __contracts_for(name.to_s, @__contracts)
        @__contracts = Contracts::List.new

        if !__contracts.first.empty?
          @__skip_other_contracts_definitions = true
          original_method = instance_method(name)
          define_method(name) do |*args, &block|
            __args = block.nil? ? args : args + [block]
            self.class.__eval_before_contracts(name.to_s, self, __args)
            result = original_method.bind(self).(*args, &block)
            self.class.__eval_after_contracts(name.to_s, self, __args, result)
            return result
          end
          @__skip_other_contracts_definitions = false
        end
      end

      def __eval_before_contracts(name, context, arguments)
        last_failure_msg = nil
        __contracts_for(name).each do |contracts|
          next if contracts.empty?
          success = true
          contracts.before_contracts.each do |contract|
            begin
              unless satisfied = contract.satisfied?(context, arguments)
                last_failure_msg = contract.message
                success = false
                break
              end
            rescue
              last_failure_msg = "Contract evaluation failed with #{$!} for #{contract.class} #{contract.message}"
              success = false
              break
            end
          end
          return if success
        end

        __contract_failure!(name, last_failure_msg, nil, arguments) if last_failure_msg
      end

      def __eval_after_contracts(name, context, arguments, result)
        __contracts_for(name).each do |contracts|
          next if contracts.empty?
          contracts.after_contracts.each do |contract|
            begin
              unless satisfied = contract.satisfied?(context, arguments, result)
              __contract_failure!(name, contract.message, result, arguments)
                break
              end
            rescue
              __contract_failure!(name, "Contract evaluation failed with #{$!} for #{contract.class} #{contract.message}", result, arguments)
            end
          end
        end
      end
    end

    module EmptyClassMethods
      def type(*args) ; end
      def pre(*args) ; end
      def post(*args) ; end
    end
  end
end
