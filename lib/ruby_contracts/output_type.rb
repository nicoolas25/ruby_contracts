module Contracts
  class OutputType < Postcondition
    def initialize(expected_class)
      @expected_class = expected_class
    end

    def message
      "the result must be an kind of #{@expected_class}"
    end

    def satisfied?(context, arguments, result=nil)
      result.kind_of? @expected_class
    end
  end
end

