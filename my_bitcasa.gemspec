# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_bitcasa/version'

Gem::Specification.new do |spec|
  spec.name          = "my_bitcasa"
  spec.version       = MyBitcasa::VERSION
  spec.authors       = ["Yoshida Tetsuya"]
  spec.email         = ["yoshida.eth0@gmail.com"]
  spec.description   = %q{MyBitcasa is an unofficial Bitcasa SDK.}
  spec.summary       = %q{MyBitcasa is an unofficial Bitcasa SDK.}
  spec.homepage      = "https://github.com/yoshida-eth0/ruby-my_bitcasa"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "active_support"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "faraday_middleware"
  spec.add_development_dependency "phantomjs"
  spec.add_development_dependency "mime-types"
end
