module Contracts
  class Contract
    def satisfied?(context, arguments, result=nil)
      raise "Contract.satisfied? must be implemented in subclasses."
    end

    def message
      raise "Contract.message must be implemented in subclasses."
    end

    def before?
      raise "Contract.before? must be implemented in subclasses."
    end

    def after?
      raise "Contract.after? must be implemented in subclasses."
    end
  end
end
