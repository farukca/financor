$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "financor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "financor"
  s.version     = Financor::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Financor."
  s.description = "TODO: Description of Financor."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

 s.add_dependency "rails", "~> 4.1.0.beta1"
  # s.add_dependency "jquery-rails"
  s.add_dependency "resque"
  #s.add_dependency "simple_form", "~> 3.1.0.rc1"#, github: "plataformatec/simple_form", branch: "master"
  s.add_dependency "execjs"
  s.add_dependency "therubyracer"
  s.add_dependency "sass-rails",   "~> 4.0.0"
  s.add_dependency "coffee-rails", "~> 4.0.0"
  s.add_dependency "uglifier", ">= 1.3.0"
  s.add_dependency "eco"
  s.add_dependency "jbuilder"
  s.add_dependency "table_for_collection"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl", "4.1.0"
  s.add_development_dependency "turn"
end
