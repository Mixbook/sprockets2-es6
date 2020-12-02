# coding: utf-8
# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'sprockets2/es6/version'

$:.unshift File.expand_path("../lib", __FILE__)
require 'sprockets2/es6/version'

Gem::Specification.new do |spec|
  spec.name          = "sprockets2-es6"
  spec.version       = Sprockets2::ES6::VERSION

  spec.summary       = "ES6 transformer for Sprockets 2"
  spec.description   = <<-EOS
    A Sprockets 2 transformer for converting ES6 to ES5 using Babel JS.
  EOS
  spec.homepage      = "https://github.com/mixbook/sprockets2-es6"
  spec.license       = "MIT"

  spec.authors       = ["Dan Schultz"]
  spec.email         = ["dan@mixbook.com"]

  spec.files         = [
    'lib/sprockets2/es6.rb',
    'lib/sprockets2/es6/version.rb',
    'LICENSE',
    'README.md'
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'babel-transpiler'
  spec.add_dependency 'babel-source', '>= 5.8.11'
  spec.add_dependency 'sprockets'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
