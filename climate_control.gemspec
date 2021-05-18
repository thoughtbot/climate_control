lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "climate_control/version"

Gem::Specification.new do |gem|
  gem.name = "climate_control"
  gem.version = ClimateControl::VERSION
  gem.authors = ["Joshua Clayton"]
  gem.email = ["joshua.clayton@gmail.com"]
  gem.description = "Modify your ENV"
  gem.summary = "Modify your ENV easily with ClimateControl"
  gem.homepage = "https://github.com/thoughtbot/climate_control"
  gem.license = "MIT"

  gem.files = `git ls-files`.split($/)
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.5.0"

  gem.add_development_dependency "rspec", "~> 3.10.0"
  gem.add_development_dependency "rake", "~> 12.3.3"
  gem.add_development_dependency "simplecov", "~> 0.9.1"
  gem.add_development_dependency "standard", "~> 1.0.0"
end
