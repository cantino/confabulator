require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Rebuild the TreeTop grammer parser"
task :rebuild do
  grammer = File.expand_path(File.join(File.dirname(__FILE__), "src", "confabulator_language.treetop"))
  output = File.expand_path(File.join(File.dirname(__FILE__), "lib", "confabulator", "language.rb"))
  puts `tt #{grammer} -o #{output}`
end
