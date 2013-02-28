# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'runic_logs/version'

Gem::Specification.new do |gem|
  gem.name          = "runic_logs"
  gem.version       = RunicLogs::VERSION
  gem.authors       = ["wlipa"]
  gem.email         = ["dojo@masterleep.com"]
  gem.description   = %q{Encodes session and request ids into the Rails log output using Unicode single-width characters, thereby using only a minimum amount of column width but allowing easy grepping for an individual session or request.}
  gem.summary       = %q{Encodes session and request ids into the Rails log output for easy grepping}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
