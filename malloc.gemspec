Gem::Specification.new do |s|
  s.name = 'malloc'
  s.version = '1.4.0'
  s.platform = Gem::Platform::RUBY
  s.summary = %q{Object for raw memory allocation and pointer operations}
  s.description = %q{This Ruby extension defines the class Hornetseye::Malloc. Hornetseye::Malloc#new allows you to allocate memory, using Hornetseye::Malloc#+ one can do pointer manipulation, and Hornetseye::Malloc#read and Hornetseye::Malloc#write provide reading Ruby strings from memory and writing Ruby strings to memory.}
  s.license = 'GPL-3+'
  s.author = %q{Jan Wedekind}
  s.email = %q{jan@wedesoft.de}
  s.homepage = %q{http://wedesoft.github.com/malloc/}
  s.files = ['Rakefile', 'README.md', 'COPYING', '.document', '.yardopts'] + Dir.glob('lib/**/*.rb') + Dir.glob('ext/*.cc') + Dir.glob('ext/*.hh') + Dir.glob('test/tc_*.rb') + Dir.glob('test/ts_*.rb')
  s.test_files = Dir.glob('test/tc_*.rb')
  s.require_paths = [ 'lib', 'ext' ]
  s.rubyforge_project = %q{hornetseye}
  s.extensions = %w{Rakefile}
  s.has_rdoc = 'yard'
  s.extra_rdoc_files = []
  s.add_development_dependency %q{rake}
end
