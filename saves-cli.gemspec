# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saves/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'saves-cli'
  spec.version       = Saves::CLI::VERSION
  spec.authors       = ['Konstantin Gredeskoul']
  spec.email         = ['kig@reinvent.one']

  spec.summary       = %q{CLI client for Wanelo Saves}
  spec.description   = %q{CLI client for Wanelo Saves}
  spec.homepage      = 'https://github.com/kigster/saves-cli' 
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'saves_client'
  spec.add_dependency 'colored2'
  spec.add_dependency 'hashie'
  spec.add_dependency 'oj'
  spec.add_dependency 'awesome_print'

  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
