require 'test_helper'

require_relative 'fixtures/preconditions_classes'


describe 'the type precondition' do
  # method contains only one precondition about the input type
  # method2 is used to see the behaviour in presence of other preconditions

  let(:instance) { SomeClass.new }

  it 'should raise an exception if there is an unexpected number of arguments' do
    proc { instance.method() }.must_raise Contracts::Error
    proc { instance.method2() }.must_raise Contracts::Error
  end

  it 'should raise an exception if an argument have the wrong type' do
    proc { instance.method('five') }.must_raise Contracts::Error
    proc { instance.method2('five') }.must_raise Contracts::Error
  end

  it 'should run and return normally if there is the expected arguments' do
    instance.method(5).must_equal 10
    instance.method2(5).must_equal 10
  end
end
