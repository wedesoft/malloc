require 'date'
Gem::Specification.new do |s|
  s.name = %q{malloc}
  s.version = '0.2.1'
  s.platform = Gem::Platform::CURRENT
  s.date = Date.today.to_s
  s.summary = %q{Object for raw memory allocation and pointer operations}
  s.description = %q{This Ruby extension defines the class Hornetseye::Malloc. Hornetseye::Malloc#new allows you to allocate memory, using Hornetseye::Malloc#+ one can do pointer manipulation, and Hornetseye::Malloc#read and Hornetseye::Malloc#write provide reading Ruby strings from memory and writing Ruby strings to memory.}
  s.author = %q{Jan Wedekind}
  s.email = %q{jan@wedesoft.de}
  s.homepage = %q{http://wedesoft.github.com/malloc/}
  s.files = [ 'README', 'COPYING' ] +
            Dir.glob( 'lib/*.rb' ) +
            [ 'ext/malloc.so' ] +
            Dir.glob( 'test/*.rb' )
  s.test_files = Dir.glob( 'test/tc_*.rb' )
  s.require_paths = [ 'lib', 'ext' ]
  s.rubyforge_project = %q{hornetseye}
  s.has_rdoc = 'yard'
  # s.extra_rdoc_files = [ 'README' ]
  # s.rdoc_options = %w{--exclude=/Makefile|.*\.(cc|hh|rb)/ --main README}
end
