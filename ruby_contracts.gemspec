# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

require 'ruby_contracts/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Nicolas ZERMATI"]
  gem.email         = ["nicoolas25@gmail.com"]
  gem.description   = %q{Micro DSL to add pre & post condition to methods. It try to bring some design by contract in the Ruby world.}
  gem.summary       = %q{Micro DSL to add pre & post condition to methods. It try to bring some design by contract in the Ruby world.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ruby_contracts"
  gem.require_paths = ["lib"]
  gem.version       = RubyContracts::VERSION
end
