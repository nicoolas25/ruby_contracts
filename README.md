# RubyContracts

RubyContracts is a small DSL to add pre & post condition to methods. It tries to bring some design by contract in the Ruby world.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_contracts'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_contracts

## Usage

    class Example
      include Contracts::DSL
      
      def initialize(val)
        @value = val
      end
      
      type :in => [Integer, Proc], :out => Numeric
      pre  "a must be > the example's value" do |a| a < @value end
      post "result must be between a and val" do |result, a| result >= a && result < @value end
      
      def method(a)
        a * 3 + yield - 4
      end
    end

Run this sample with `ENABLE_ASSERTION=1 bundle exec ruby example.rb`.

Without the environment variable `ENABLE_ASSERTION` you have zero overhead and zero verification.

## Class inheritance

When you inherit a class that contains contracts, all contracts must be satified by the subclass.

If you override a method, you still have to satisfy the existing postconditions for this method and you can add some others.
This means that postconditions groups are AND-ed and preconditions groups are OR-ed by inheritance.

See the [issue #1](https://github.com/nicoolas25/ruby_contracts/issues/1) for an example.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
