#!/usr/bin/env ruby
require 'date'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rbconfig'

PKG_NAME = 'malloc'
PKG_VERSION = '0.2.3'
CXX = ENV[ 'CXX' ] || 'g++'
STRIP = ENV[ 'STRIP' ] || 'strip'
RB_FILES = FileList[ 'lib/**/*.rb' ]
CC_FILES = FileList[ 'ext/*.cc' ]
HH_FILES = FileList[ 'ext/*.hh' ]
TC_FILES = FileList[ 'test/tc_*.rb' ]
TS_FILES = FileList[ 'test/ts_*.rb' ]
SO_FILE = "ext/#{PKG_NAME}.so"
PKG_FILES = [ 'Rakefile', 'README', 'COPYING', '.document' ] +
            RB_FILES + CC_FILES + HH_FILES + TS_FILES + TC_FILES
BIN_FILES = [ 'README', 'COPYING', '.document', SO_FILE ] +
            RB_FILES + TS_FILES + TC_FILES
SUMMARY = %q{Object for raw memory allocation and pointer operations}
DESCRIPTION = %q{This Ruby extension defines the class Hornetseye::Malloc. Hornetseye::Malloc#new allows you to allocate memory, using Hornetseye::Malloc#+ one can do pointer manipulation, and Hornetseye::Malloc#read and Hornetseye::Malloc#write provide reading Ruby strings from memory and writing Ruby strings to memory.}
AUTHOR = %q{Jan Wedekind}
EMAIL = %q{jan@wedesoft.de}
HOMEPAGE = %q{http://wedesoft.github.com/malloc/}

OBJ = CC_FILES.ext 'o'
$CXXFLAGS = ENV[ 'CXXFLAGS' ] || ''
$CXXFLAGS = "#{$CXXFLAGS} -fPIC"
if Config::CONFIG[ 'rubyhdrdir' ]
  $CXXFLAGS += "#{$CXXFLAGS} -I#{Config::CONFIG[ 'rubyhdrdir' ]} " +
              "-I#{Config::CONFIG[ 'rubyhdrdir' ]}/#{Config::CONFIG[ 'arch' ]}"
else
  $CXXFLAGS += "#{$CXXFLAGS} -I#{Config::CONFIG[ 'archdir' ]}"
end
$LIBRUBYARG = Config::CONFIG[ 'LIBRUBYARG' ]
$SITELIBDIR = Config::CONFIG[ 'sitelibdir' ]
$SITEARCHDIR = Config::CONFIG[ 'sitearchdir' ]

task :default => :all

task :all => [ SO_FILE ]

file SO_FILE => OBJ do |t|
   sh "#{CXX} -shared -o #{t.name} #{OBJ} #{$LIBRUBYARG}"
   sh "#{STRIP} --strip-all #{t.name}"
end

task :test => [ SO_FILE ]

desc 'Install Ruby extension'
task :install => :all do
  verbose true do
    for f in RB_FILES do
      FileUtils.mkdir_p "#{$SITELIBDIR}/#{File.dirname( f[ 4 .. -1 ] )}"
      FileUtils.cp_r f, "#{$SITELIBDIR}/#{f[ 4 .. -1 ]}"
    end
    FileUtils.mkdir_p $SITEARCHDIR
    FileUtils.cp SO_FILE, "#{$SITEARCHDIR}/#{File.basename SO_FILE}"
  end
end

desc 'Uninstall Ruby extension'
task :uninstall do
  verbose true do
    for f in RB_FILES do
      FileUtils.rm_f "#{$SITELIBDIR}/#{f[ 4 .. -1 ]}"
    end
    FileUtils.rm_f "#{$SITEARCHDIR}/#{File.basename SO_FILE}"
  end
end

Rake::TestTask.new do |t|
  t.libs << 'ext'
  t.test_files = TC_FILES
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new :yard do |y|
    y.options << '--no-private'
    y.files << FileList[ 'lib/**/*.rb' ]
  end
rescue LoadError
  STDERR.puts 'Please install \'yard\' if you want to generate documentation'
end

Rake::PackageTask.new PKG_NAME, PKG_VERSION do |p|
  p.need_tar = true
  p.package_files = PKG_FILES
end

begin
  require 'rubygems/builder'
  $SPEC = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.platform = Gem::Platform::RUBY
    s.date = Date.today.to_s
    s.summary = SUMMARY
    s.description = DESCRIPTION
    s.author = AUTHOR
    s.email = EMAIL
    s.homepage = HOMEPAGE
    s.files = PKG_FILES
    s.test_files = TC_FILES
    s.require_paths = [ 'lib', 'ext' ]
    s.rubyforge_project = %q{hornetseye}
    s.extensions = %w{Rakefile}
    s.has_rdoc = 'yard'
    s.extra_rdoc_files = []
    s.rdoc_options = %w{--no-private}
  end
  GEM_SOURCE = "#{PKG_NAME}-#{PKG_VERSION}.gem"
  $BINSPEC = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.platform = Gem::Platform::CURRENT
    s.date = Date.today.to_s
    s.summary = SUMMARY
    s.description = DESCRIPTION
    s.author = AUTHOR
    s.email = EMAIL
    s.homepage = HOMEPAGE
    s.files = BIN_FILES
    s.test_files = TC_FILES
    s.require_paths = [ 'lib', 'ext' ]
    s.rubyforge_project = %q{hornetseye}
    s.has_rdoc = 'yard'
    s.extra_rdoc_files = []
    s.rdoc_options = %w{--no-private}
  end
  GEM_BINARY = "#{PKG_NAME}-#{PKG_VERSION}-#{$BINSPEC.platform}.gem"
  desc "Build the gem file #{GEM_SOURCE}"
  task :gem => [ "pkg/#{GEM_SOURCE}" ]
  file "pkg/#{GEM_SOURCE}" => [ 'pkg' ] + $SPEC.files do
    Gem::Builder.new( $SPEC ).build
    verbose true do
      FileUtils.mv GEM_SOURCE, "pkg/#{GEM_SOURCE}"
    end
  end
  desc "Build the gem file #{GEM_BINARY}"
  task :gem_binary => [ "pkg/#{GEM_BINARY}" ]
  file "pkg/#{GEM_BINARY}" => [ 'pkg' ] + $BINSPEC.files do
    when_writing 'Creating GEM' do
      Gem::Builder.new( $BINSPEC ).build
      verbose true do
        FileUtils.mv GEM_BINARY, "pkg/#{GEM_BINARY}"
      end
    end
  end
rescue LoadError
  STDERR.puts 'Please install \'rubygems\' if you want to create Gem packages'
end

rule '.o' => '.cc' do |t|
   sh "#{CXX} #{$CXXFLAGS} -c -o #{t.name} #{t.source}"
end

file 'ext/error.o' => [ 'ext/error.cc', 'ext/error.hh' ]
file 'ext/malloc.o' => [ 'ext/malloc.cc', 'ext/malloc.hh', 'ext/error.hh' ]

CLEAN.include 'ext/*.o'
CLOBBER.include SO_FILE, 'doc'
