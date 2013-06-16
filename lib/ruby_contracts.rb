require "ruby_contracts/version"

module Contracts
  class Error < Exception ; end

  autoload :List,          'ruby_contracts/list'
  autoload :Contract,      'ruby_contracts/contract'
  autoload :Precondition,  'ruby_contracts/precondition'
  autoload :Postcondition, 'ruby_contracts/postcondition'
  autoload :InputType,     'ruby_contracts/input_type'
  autoload :OutputType,    'ruby_contracts/output_type'
  autoload :DSL,           'ruby_contracts/dsl'
end
