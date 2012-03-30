$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "settingsdb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "settingsdb-rails"
  s.version     = SettingsDB::VERSION
  s.authors     = ["Michael Grubb"]
  s.email       = ["spamtrap@dailyvoid.com"]
  s.homepage    = "https://github.com/mgrubb/settingsdb-rails"
  s.summary     = "Keep application settings in the database"
  s.description = "Keep application settings in the database"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.4"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'turn'
  s.add_development_dependency 'pry'

end
