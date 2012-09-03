# RubyContracts

RubyContracts is a small DSL to add pre & post condition to methods. It try to bring some design by contract in the Ruby world.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request