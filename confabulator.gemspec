# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "confabulator/version"

Gem::Specification.new do |s|
  s.name        = "confabulator"
  s.version     = Confabulator::VERSION
  s.authors     = ["Andrew Cantino"]
  s.email       = ["andrew@iterationlabs.com"]
  s.homepage    = "https://github.com/cantino/confabulator"
  s.summary     = %q{Ruby generative grammer for conversational text}
  s.description = %q{}

  s.rubyforge_project = "confabulator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "treetop"
  s.add_runtime_dependency "loggability"
  s.add_runtime_dependency "linguistics"
end
