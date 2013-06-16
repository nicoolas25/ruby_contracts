module Contracts
  class Postcondition < Contract
    attr_reader :message

    def initialize(message, block)
      @message = "invalid postcondition: #{message || 'no message given'}"
      @block = block
    end

    def satisfied?(context, arguments, result=nil)
      context.instance_exec(result, *arguments, &@block)
    end

    def before?
      false
    end

    def after?
      true
    end
  end
end
