#!/bin/env ruby

require_relative 'childwithredef'
require_relative 'parent'

# In the 'initialize' routine, the postcondition is not violated, but
# ruby_contracts incorrectly throws an invalid postcondition exception -
# for both ChildWithRedef and Parent.
p = Parent.new(10, 2)
