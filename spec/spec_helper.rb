require "simplecov"
SimpleCov.start

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__))

require "rubygems"
require "rspec"
require "climate_control"
