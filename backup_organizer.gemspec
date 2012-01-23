# -*- encoding: utf-8 -*-
require File.expand_path('../lib/backup_organizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thorben Schröder"]
  gem.email         = ["stillepost@gmail.com"]
  gem.description   = %q{Organizes backup files in folders in patterns that can be defined by the user.}
  gem.summary       = %q{If backups should only be kept around for a certain time and be stored sparsely (weekly, monthly, yearly, whatever) after that backup_organizer can do that for you.}
  gem.homepage      = "http://github.com/walski/backup_organizer"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "backup_organizer"
  gem.require_paths = ["lib"]
  gem.version       = BackupOrganizer::VERSION

  gem.add_development_dependency 'rspec', '>= 2'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'ruby_gntp'
end
