require 'test_helper'

require_relative 'fixtures/dsl_classes'

describe 'the implies keyword' do
  it 'should be false and raise a Contracts::Error when the condition is true but the implication is false' do
    proc { FalseImplies.new.method1 }.must_raise Contracts::Error
  end

  it 'should be true and not produce any Contracts::Error when the condition is false' do
    TrueImplies.new.method1.must_be_nil
  end

  it 'should be true and not produce any Contracts::Error when the condition is true and the implication is true' do
    TrueImplies.new.method2.must_be_nil
  end
end
