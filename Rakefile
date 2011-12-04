require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :rebuild do
  grammer = File.expand_path(File.join(File.dirname(__FILE__), "src", "confabulator.treetop"))
  output = File.expand_path(File.join(File.dirname(__FILE__), "lib", "confabulator", "grammer.rb"))
  puts `tt #{grammer} -o #{output}`
end
