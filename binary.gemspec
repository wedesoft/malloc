require 'date'
Gem::Specification.new do |s|
  s.name = %q{malloc}
  s.version = '0.1.6'
  s.platform = Gem::Platform::CURRENT
  s.date = Date.today.to_s
  s.summary = %q{Object for raw memory allocation and pointer operations}
  s.description = %q{This gem defines the class Malloc. Malloc#new allows you to allocate memory, using Malloc#+ one can do pointer manipulation, and Malloc#read and Malloc#write provide reading Ruby strings from memory and writing Ruby strings to memory.}
  s.author = %q{Jan Wedekind}
  s.email = %q{jan@wedesoft.de}
  s.homepage = %q{http://wedesoft.github.com/malloc/}
  s.files = [ 'README', 'COPYING' ] +
            Dir.glob( 'lib/*.rb' ) + [ 'ext/malloc.so' ]
  s.require_paths = [ 'lib', 'ext' ]
  s.rubyforge_project = %q{hornetseye}
  s.has_rdoc = true
  s.extra_rdoc_files = [ 'README' ]
  s.rdoc_options = %w{--exclude=/Makefile|.*\.(cc|hh|rb)/ --main README}
end
