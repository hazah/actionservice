# -*- encoding: utf-8 -*-
require File.expand_path('../lib/action_service/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hartog C. de Mik"]
  gem.email         = ["hartog@organisedminds.com"]
  gem.description   = %q{A action_service with a perimeter, a guard and a sandbox}
  gem.summary       = %q{Provide a action_service for your code to play in}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "actionservice"
  gem.require_paths = ["lib"]
  gem.version       = ActionService::VERSION

  gem.add_dependency('activesupport', ['> 3'])

  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec', ['~> 2.11'])
  gem.add_development_dependency('mocha')
  gem.add_development_dependency('activerecord', ['> 3'])
  gem.add_development_dependency('mysql2')
  gem.add_development_dependency('jdbc-mysql')
end
