require "ruby_contracts/version"

module Contracts
  class Error < Exception ; end

  module DSL
    def self.included(base)
      base.extend Contracts::DSL::ClassMethods
    end

    module ClassMethods
      def self.extended(base)
        base.instance_eval "@__contracts = {:before => [], :after => []}"
      end

      def __contract_failure!(name, message, result, *args)
        args.pop if args.last.kind_of?(Proc)
        raise Contracts::Error.new("#{self}##{name}(#{args.join ', '}) => #{result || "?"} ; #{message}.")
      end

      def type(options)
        @__contracts[:before] << [:type, options[:in]] if ENV['ENABLE_ASSERTION'] && options.has_key?(:in)
        @__contracts[:after] << [:type, options[:out]] if ENV['ENABLE_ASSERTION'] && options.has_key?(:out)
      end

      def pre(message=nil, &block)
        @__contracts[:before] << [:params, message, block] if ENV['ENABLE_ASSERTION']
      end

      def post(message=nil, &block)
        @__contracts[:after] << [:result, message, block] if ENV['ENABLE_ASSERTION']
      end

      def method_added(name)
        if ENV['ENABLE_ASSERTION'] && (!@__contracts[:before].empty? || !@__contracts[:after].empty?)
          __contracts_copy = @__contracts
          @__contracts = {:before => [], :after => []}

          original_method_name = "#{name}__with_contracts"
          define_method(original_method_name, instance_method(name))


          count = 0
          before_contracts = __contracts_copy[:before].reduce("") do |code, contract|
            type, *args = contract
            case type
            when :type
              classes = args[0]
              code << "if __args.size < #{classes.size} then\n"
              code << "  self.class.__contract_failure!('#{name}', \"need at least #{classes.size} arguments (%i given)\" % [__args.size], nil, *args)\n"
              code << "else\n"
              conditions = []
              classes.each_with_index{ |klass, i| conditions << "__args[#{i}].kind_of?(#{klass})" }
              code << "  if !(#{conditions.join(' && ')}) then\n"
              code << "    self.class.__contract_failure!('#{name}', 'input type error', nil, *__args)\n"
              code << "  end\n"
              code << "end\n"
              code

            when :params
              # Define a method that verify the assertion
              contract_method_name = "__verify_contract_#{name}_in_#{count = count + 1}"
              define_method(contract_method_name) { |*params| self.instance_exec(*params, &args[1]) }

              code << "if !#{contract_method_name}(*__args) then\n"
              code << "  self.class.__contract_failure!('#{name}', \"invalid precondition: #{args[0]}\", nil, *__args)\n"
              code << "end"
              code
            else
              code
            end
          end

          after_contracts = __contracts_copy[:after].reduce("") do |code, contract|
            type, *args = contract
            case type
            when :type
              code << "if !result.kind_of?(#{args[0]}) then\n"
              code << "self.class.__contract_failure!(name, \"result must be a kind of '#{args[0]}' not '%s'\" % [result.class.to_s], result, *__args)\n"
              code << "end\n"
              code
            when :result
              # Define a method that verify the assertion
              contract_method_name = "__verify_contract_#{name}_out_#{count = count + 1}"
              define_method(contract_method_name) { |*params| self.instance_exec(*params, &args[1]) }

              code << "if !#{contract_method_name}(result, *__args) then\n"
              code << "  self.class.__contract_failure!('#{name}', \"invalid postcondition: #{args[0]}\", result, *__args)\n"
              code << "end"
              code
            else
              code
            end
          end

          method = <<-EOM
            def #{name}(*args, &block)
              __args = block.nil? ? args : args + [block]
              #{before_contracts}
              result = #{original_method_name}(*args, &block)
              #{after_contracts}
              return result
            end
          EOM

          class_eval method
        end
      end
    end
  end
end
