Gem::Specification.new do |s|
  s.name        = "bitkassa"
  s.version     = "0.0.2"
  s.summary     = "Bitkassa"
  s.description = "Ruby interface to the Bitkassa API"
  s.authors     = ["Bèr Kessels"]
  s.email       = "ber@berk.es"
  s.files       = ["lib/bitkassa.rb"]
  s.homepage    = "http://github.com/berkes/bitkassa"
  s.license     = "MIT"

  s.add_dependency "httpi"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "webmock"
  s.add_development_dependency "rubocop-git"
end
