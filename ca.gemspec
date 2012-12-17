# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ca/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wojciech Bozek"]
  gem.email         = ["wbozek@fractalsoft.org"]
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ca"
  gem.require_paths = ["lib"]
  gem.version       = Ca::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rails_best_practices"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "guard-rails_best_practices"

  gem.add_dependency "nokogiri"
  gem.add_dependency "mechanize"
  gem.add_dependency "loofah"
  gem.add_dependency 'rb-inotify', '~> 0.8.8'
  gem.add_dependency "gruff"
  gem.add_dependency "rmagick"
  gem.add_dependency "activesupport"
end
