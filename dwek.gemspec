$:.push File.expand_path('../lib', __FILE__)

require 'dwek/version'

Gem::Specification.new do |s|
  s.name        = 'dwek'
  s.version     = Dwek::VERSION
  s.authors     = ['Kevin Deisz']
  s.email       = ['kdeisz@trialnetworks.com']
  s.homepage    = 'https://github.com/kddeisz/dwek'
  s.summary     = 'For awesome.'
  s.description = 'Extra awesome.'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.executables << 'dwek'
  s.test_files = Dir['test/**/*']

  s.add_dependency 'activerecord', '> 4'
  s.add_dependency 'activesupport', '> 4'
  s.add_dependency 'mysql2', '>= 0.3'
  s.add_dependency 'racc', '>= 1.4'
end
