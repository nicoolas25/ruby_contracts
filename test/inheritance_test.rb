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
      end
    end
  end
end
