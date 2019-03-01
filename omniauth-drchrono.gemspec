# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-drchrono/version'

Gem::Specification.new do |gem|
  gem.name          = "omniauth-drchrono"
  gem.version       = OmniAuth::DrChrono::VERSION
  gem.authors       = ["Eric Shelley"]
  gem.email         = ["eric@webdesignbakery.com"]
  gem.description   = %q{A DrChrono OAuth2 strategy for OmniAuth.}
  gem.summary       = %q{A DrChrono OAuth2 strategy for OmniAuth.}
  gem.homepage      = "https://github.com/bartimaeus/omniauth-dr-chrono"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'omniauth-oauth2'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
