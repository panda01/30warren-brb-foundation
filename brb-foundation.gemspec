$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "brb/foundation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "brb-foundation"
  s.version     = Brb::Foundation::VERSION
  s.authors     = ["Jack Jennings"]
  s.email       = ["jack@remote.gd"]
  s.homepage    = "https://github.com/noeassociates/brb-foundation"
  s.summary     = "Brb/Foundation::API bridge"
  s.description = "Injects a Buyer model and accompanying builders into a Brb-based Rails application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"

  s.add_development_dependency "sqlite3"
end
