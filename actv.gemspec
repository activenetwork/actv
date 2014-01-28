# -*- encoding: utf-8 -*-
require File.expand_path('../lib/actv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'faraday', '~> 0.8'
  gem.add_dependency 'multi_json', '~> 1.3'
  gem.add_dependency 'simple_oauth', '~> 0.1.6'
  gem.add_dependency 'nokogiri'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'maruku'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'active_support'

  
  gem.authors       = ["Nathaniel Barnes"]
  gem.email         = ["Nathaniel.Barnes@activenetwork.com"]
  gem.description   = %q{A Ruby wrapper for the Active API}
  gem.summary       = %q{Active API}
  gem.homepage      = "http://developer.active.com"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "actv"
  gem.require_paths = ["lib"]
  gem.version       = ACTV::VERSION
end
