# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/mblox/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-mblox"
  spec.version       = Rails::Mblox::VERSION
  spec.authors       = ["Oxyless"]
  spec.email         = ["clement.bruchon@gmail.com"]
  spec.summary       = %q{Implementation of Mblox Api for Rails}
  spec.description   = %q{Implementation of Mblox Api for Rails}
  spec.homepage      = "https://github.com/Oxyless/rails-mblox"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
