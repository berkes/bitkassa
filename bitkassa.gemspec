Gem::Specification.new do |s|
  s.name        = "bitkassa"
  s.version     = "0.1.2"
  s.summary     = "Bitkassa"
  s.description = "Ruby interface to the Bitkassa API"
  s.authors     = ["Bèr Kessels"]
  s.email       = "ber@berk.es"
  s.files       = ["lib/bitkassa.rb"]
  s.homepage    = "http://github.com/berkes/bitkassa"
  s.required_ruby_version = ">= 2.0"
  s.license     = "MIT"

  s.add_dependency "httpi", "~> 2.4"

  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "minitest", "~> 5.8"
  s.add_development_dependency "webmock", "~> 1.22"
  s.add_development_dependency "rubocop-git", "~> 0.0"
end
