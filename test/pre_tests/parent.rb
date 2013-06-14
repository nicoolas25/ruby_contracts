require 'ruby_contracts'

class Parent
  include Contracts::DSL
  EPSILON = 1e-7
  attr_reader :value, :minimum_incr

  type :in => [Numeric, Numeric]
  pre  "val >= 0, mininc > 0" do |v, mininc| v >= 0 && mininc > 0 end
  def initialize(v, mininc)
    @value = v
    @minimum_incr = mininc
  end

  type :in => [Numeric], :out => Numeric
  pre  "n >= minimum_incr" do |n| n >= minimum_incr end
  post "value == old value + n" do "[dummy]" end
  def increment(n)
    @value += n
  end

  def to_s
    value.to_s
  end
end
