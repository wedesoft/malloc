require 'date'
Gem::Specification.new do |s|
  s.name = %q{malloc}
  s.version = '1.0.0'
  # gem1.8 help platforms
  # CURRENT, LINUX_586, WIN32, RUBY, RUBY, or DARWIN
  s.platform = Gem::Platform::CURRENT
  # s.platform = 'x86-mswin32-universal'
  # s.platform = Gem::Platform::WIN32
  s.date = Date.today.to_s
  s.summary = %q{Raw memory access}
  s.description = %q{Object for raw memory allocation and pointer operations}
  s.author = %q{Jan Wedekind}
  s.email = %q{jan@wedesoft.de}
  s.homepage = %q{http://www.wedesoft.de/}
  s.files = [ 'malloc.gemspec', 'README', 'COPYING' ] +
            Dir.glob( 'lib/*.rb' ) +
            Dir.glob( 'ext/*.cc' ) +
            Dir.glob( 'ext/*.hh' ) +
            [ 'ext/extconf.rb',
              'tests/ts_malloc.rb' ]
  s.test_files = [ 'tests/ts_malloc.rb' ]
  # s.default_executable = %q{...}
  # s.executables = Dir.glob( 'bin/*' ).collect { |f| File.basename f }
  s.require_paths = [ 'lib', 'ext' ]
  # s.rubyforge_project = %q{malloc}
  s.extensions = %w{ext/extconf.rb}
  s.has_rdoc = false
  # s.extra_rdoc_files = %w{README}
  # s.rdoc_options = %w{--main README}
  s.required_ruby_version = '>= 1.8.5'
  s.requirements << 'GNU/Linux'
end
