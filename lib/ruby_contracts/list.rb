module Contracts
  class List < Array
    def before_contracts
      self.class.new(select{ |contract| contract.before? })
    end

    def after_contracts
      self.class.new(select{ |contract| contract.after? })
    end
  end
end
