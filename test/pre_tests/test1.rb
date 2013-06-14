#!/bin/env ruby

require_relative 'childwithredef'
require_relative 'parent'

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
p = Parent.new(10, 2)
begin
  c = ChildWithRedef.new(10, 0) # 'initialize' precondition violation
  testrep(name, false, c)
rescue Exception => x
  testrep(name, true, c, x)
end
c = ChildWithRedef.new(10, 3)
@test += 1
name = 'detect violated precondition for "increment" (parent)'
puts "test #{@test} #{@line}"
puts "p, c: #{p}, #{c}"
p.increment(3)
c.increment(3)
puts "p, c: #{p}, #{c}"
begin
  p.increment(1)  # 'increment' precondition violation
  testrep(name, false, c)
rescue Exception => x
  testrep(name, true, c, x)
end
@test += 1
name = 'detect violated precondition for "increment" (child)'
puts "test #{@test} #{@line}"
begin
  c.increment(2)  # increment precondition violation (! 2 >= 3)
  testrep(name, false, c)
  puts "(Violated precondition for 'increment' is not caught in vsn. 0.2.3)"
  puts "(Child class does not change parent's 'increment' precondition,\n" +
    "so parent precondition should be violated (i.e., 2 >= 3), but no\n" +
    "violation is detected.)"
rescue Exception => x
  testrep(name, true, c, x)
end
