require 'date'
Gem::Specification.new do |s|
  s.name = %q{malloc}
  s.version = '0.1.5'
  # gem1.8 help platforms
  # CURRENT, LINUX_586, WIN32, RUBY, RUBY, or DARWIN
  # s.platform = Gem::Platform::RUBY
  # s.platform = 'x86-mswin32-universal'
  s.platform = Gem::Platform::CURRENT
  s.date = Date.today.to_s
  s.summary = %q{Object for raw memory allocation and pointer operations}
  s.description = %q{This gem defines the class Malloc. Malloc#new allows you to allocate memory, using Malloc#+ one can do pointer manipulation, and Malloc#read and Malloc#write provide reading Ruby strings from memory and writing Ruby strings to memory.}
  s.author = %q{Jan Wedekind}
  s.email = %q{jan@wedesoft.de}
  s.homepage = %q{http://wedesoft.github.com/malloc/}
  s.files = [ 'README', 'COPYING' ] +
            Dir.glob( 'lib/*.rb' ) +
            Dir.glob( 'ext/*.so' )
  # s.test_files = [ 'test/ts_malloc.rb' ]
  # s.default_executable = %q{...}
  # s.executables = Dir.glob( 'bin/*' ).collect { |f| File.basename f }
  s.require_paths = [ 'lib', 'ext' ]
  s.rubyforge_project = %q{hornetseye}
  # s.extensions = %w{ext/extconf.rb}
  s.has_rdoc = false
  # s.extra_rdoc_files = [ 'README' ]
  # s.rdoc_options = %w{--main README}
  s.required_ruby_version = '>= 1.8.5'
  # s.requirements << 'GNU/Linux'
end
