$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'

require 'envmod'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }
