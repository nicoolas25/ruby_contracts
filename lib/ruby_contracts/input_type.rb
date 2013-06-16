module Contracts
  class InputType < Precondition
    attr_reader :message

    def initialize(expected_classes)
      @expected_classes = expected_classes
      @expected_argument_count = expected_classes.size
    end

    def satisfied?(context, arguments, result=nil)
      if !match_size?(arguments)
        @message = "the method expect #{@expected_argument_count} arguments when #{arguments.size} was given"
        false
      elsif unmatched = unmatched_type_from(arguments)
        i, arg, expected_klass = unmatched
        @message = "the method expect a kind of #{expected_klass} for argument ##{i} when a kind of #{arg.class} was given"
        false
      else
        true
      end
    end

    private

      def match_size?(arguments)
        arguments.size == @expected_argument_count
      end

      def unmatched_type_from(arguments)
        unmatched = nil
        arguments.zip(@expected_classes).each_with_index do |(arg, klass), i|
          unless arg.kind_of?(klass)
            unmatched = [i, arg, klass]
            break
          end
        end
        unmatched
      end
  end
end

