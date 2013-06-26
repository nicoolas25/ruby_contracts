require 'test_helper'

require_relative 'fixtures/inheritance_classes'

describe 'the contracts behavior in an inheritance context' do
  describe 'the initialization process' do
    describe 'with valid arguments' do
      it 'should not raise any exception' do
        Parent.new(10, 2).wont_be_nil
        ChildWithRedef.new(10, 2).wont_be_nil
      end
    end

    describe 'with invalid arguments' do
      it 'should raise an Contracts::Error' do
        proc { ChildWithRedef.new(10, 0) }.must_raise Contracts::Error
      end
    end
  end


  describe 'the redifinition of an existing method with precondition' do
    describe 'the child\'s overriden method call' do
      describe 'the child specifies no precondition' do
        let(:child) { ChildWithRedef.new(10,3) }
        it 'satisfies the parent preconditions' do
          child.increment(4)
          proc { child.increment(3) }.must_raise Contracts::Error
        end
      end

      describe 'the child specifies additionnal preconditions' do
        let(:child) { ChildWithAddedPrecondition.new(10, 3) }
        it 'satisfies the parent OR the child preconditions' do
          child.increment(3)
          proc { child.increment(2) }.must_raise Contracts::Error
        end

        it 'fails with the deepest failing precondition message' do
          begin
            child.increment(2)
            true.must_equal false # Force a failure
          rescue Contracts::Error
            $!.message.must_include 'n >= minimum_incr'
          end
        end
      end

    end

    describe 'the super keyword usage' do
      let(:child) { ChildWithSuper.new(10, 3) }

      it 'does not raise any error' do
        child.increment(5).wont_be_nil
      end
    end
  end

  describe 'the redifinition of an existing method with postcondition' do
    describe 'the child specifies unsatisfiable postconditions' do
      let(:child) { ChildWithImpossiblePostcondition.new(10, 3) }
      it 'fails with an unsatisfiable postcondition' do
        begin
          child.increment(4)
          true.must_equal false # Force a failure
        rescue Contracts::Error
          $!.message.must_match /postcondition.*impossible/
        end
      end
    end

    describe 'the child specifies a satisfiable postcondition' do
      let(:child) { ChildWithReasonablePostcondition.new(10, 3) }
      it 'succeeds with an reasonable postcondition' do
#        child.increment(3) # Exposes bug: postcondition masks precondition
        child.increment(4)
      end
    end
  end

end
