# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'envmod/version'

Gem::Specification.new do |gem|
  gem.name          = 'envmod'
  gem.version       = Envmod::VERSION
  gem.authors       = ['Joshua Clayton']
  gem.email         = ['joshua.clayton@gmail.com']
  gem.description   = %q{Modify your ENV}
  gem.summary       = %q{Modify your ENV easily with Envmod}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'rspec'
end
