#!/bin/env ruby

require_relative 'childwithaddedprecondition'

@test = 1

def testrep(name, status, obj, exc = nil)
  if status then status_str = 'SUCCEEDED' else status_str = 'FAILED' end
  puts "test #{@test} - #{name}: #{status_str}"
  if obj then puts "object: #{obj}" end
  if exc then puts exc end
end

@line = '-' * 66
name = 'detect violated precondition for "new" (child)'
puts "test #{@test} #{@line}"
begin
  c = ChildWithAddedPrecondition.new(10, 0) # 'initialize' precond. violation
  testrep(name, false, c)
rescue Exception => x
  testrep(name, true, c, x)
end

c = ChildWithAddedPrecondition.new(10, 3)
@test += 1
name = 'detect violated precondition for "increment" (child)'
puts "test #{@test} #{@line}"
puts "c: #{c}"
# This succeeds - checking of the weakened precondition apparently succeeds
# when the precondition is met (n >= (minimum_incr - 1).abs)
c.increment(2)
puts "c: #{c}"
# This call fails - the precondition is violated [i.e., 1 >= 2].  It looks
# like, perhaps, the false precondition is detected, since an exception is
# thrown, but it's not a precondition error (the message is
# "wrong number of arguments (0 for 3)").  It looks like, perhaps, a bug in
# in the error reporting logic in ruby_contracts causes the wrong #
# arguments error to occur while attempting to report the actual problem
# (precondition violation).
c.increment(1)
