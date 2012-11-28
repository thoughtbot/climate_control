require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec)

desc "Run specs"
RSpec::Core::RakeTask.new('spec:acceptance') do |t|
    t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
      # Put spec opts in a file named .rspec in root
    # end
end
task default: :rspec
