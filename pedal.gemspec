# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pedal/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Collin Schaafsma"]
  gem.email         = ["collin@quickleft.com"]
  gem.description   = %q{Pedal is a fast, Webmachine based full-stack Web Framework written in Ruby for building extendable, maintainable applications quickly.}
  gem.summary       = %q{Pedal is a fast, Webmachine based full-stack Web Framework written in Ruby for building extendable, maintainable applications quickly.
                         Pedal divides itself into a client server model allowing for easy de-coupling and is ideal for building Hypermedia APIs
                         with rich Javascript based clients. Pedal is simple and stays out of the way, while instituting proper design patterns beyond the typical
                         model, view, controller paradigm. Start Pedaling!}
  gem.homepage      = "https://github.com/collinschaafsma/pedal"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pedal"
  gem.require_paths = ["lib"]
  gem.version       = Pedal::VERSION

  gem.add_dependency 'webmachine', '~> 0.4.2'
  gem.add_dependency 'roar',       '~> 0.10.1'
  gem.add_dependency 'thor',       '~> 0.15.2'
end
