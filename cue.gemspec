$:.unshift File.expand_path("../lib", __FILE__)
require 'cue/version'

Gem::Specification.new do |gem|
  gem.name        = 'cue'
  gem.version     = Cue::VERSION
  gem.summary     = 'keep track of stuff'
  gem.description = 'Cue is a simple command line tool for keeping track of stuff.'
  gem.author      = 'John Doe'
  gem.email       = 'arcsum42@gmail.com'
  gem.license     = 'MIT'
  gem.homepage    = 'https://github.com/arcsum/cue'
  gem.bindir      = 'bin'
  gem.files       = Dir['README.md', 'LICENSE.md', 'lib/**/*.rb', 'bin/*']
  
  Dir['bin/*'].each do |executable|
    gem.executables << File.basename(executable)
  end
  
  gem.add_dependency 'redis', '~> 3.0.4'
end
