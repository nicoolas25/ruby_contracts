module Contracts
  class Precondition < Contract
    attr_reader :message

    def initialize(message, block)
      @message = "invalid precondition: #{message || 'no message given'}"
      @block = block
    end

    def satisfied?(context, arguments, result=nil)
      context.instance_exec(*arguments, &@block)
    end

    def before?
      true
    end

    def after?
      false
    end
  end
end
