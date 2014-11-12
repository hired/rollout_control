$:.push File.expand_path("../lib", __FILE__)
require "rollout_control/version"

Gem::Specification.new do |s|
  s.name        = "rollout_control"
  s.version     = RolloutControl::VERSION
  s.authors     = ["Aaron Royer"]
  s.email       = ["aaronroyer@gmail.com"]
  s.homepage    = "https://github.com/hired/rollout_control"
  s.description = "rollout API as a Rails engine"
  s.summary     = "Allows controlling rollout remotely with clients such as chat bots"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "rollout", "~> 2.0"

  s.add_development_dependency "fakeredis"
  s.add_development_dependency "pry"
end
