class SomeClass
  include Contracts::DSL

  type :in => [Numeric]
  def method(num)
    num + 5
  end

  type :in => [Numeric]
  pre 'input should be > 0' do |input| input > 0 end
  def method2(num)
    num + 5
  end
end
