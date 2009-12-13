#!/usr/bin/env ruby
# This Rakefile is not completed yet.
require 'date'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rbconfig'
require 'yard'

PKG_NAME = 'malloc'
PKG_VERSION = '0.2.3'
CXX = ENV[ 'CXX' ] || 'g++'
STRIP = ENV[ 'STRIP' ] || 'strip'
PKG_FILES = [ 'README', 'COPYING', '.document' ] +
            FileList[ 'lib/*.rb' ] +
            FileList[ 'ext/*.cc' ] +
            FileList[ 'ext/*.hh' ] +
            FileList[ 'test/*.rb' ]
SRC = FileList[ 'ext/*.cc' ]
TC = FileList[ 'test/tc_*.rb' ]
OBJ = SRC.ext 'o'
SUMMARY = %q{Object for raw memory allocation and pointer operations}
DESCRIPTION = %q{This Ruby extension defines the class Hornetseye::Malloc. Hornetseye::Malloc#new allows you to allocate memory, using Hornetseye::Malloc#+ one can do pointer manipulation, and Hornetseye::Malloc#read and Hornetseye::Malloc#write provide reading Ruby strings from memory and writing Ruby strings to memory.}
AUTHOR = %q{Jan Wedekind}
EMAIL = %q{jan@wedesoft.de}
HOMEPAGE = %q{http://wedesoft.github.com/malloc/}

$CXXFLAGS = ENV[ 'CXXFLAGS' ] || ''

if Config::CONFIG[ 'rubyhdrdir' ]
  $CXXFLAGS += "#{$CXXFLAGS} -I#{Config::CONFIG[ 'rubyhdrdir' ]} " +
              "-I#{Config::CONFIG[ 'rubyhdrdir' ]}/#{Config::CONFIG[ 'arch' ]}"
else
  $CXXFLAGS += "#{$CXXFLAGS} -I#{Config::CONFIG[ 'archdir' ]}"
end
$RUBYLIB = Config::CONFIG[ 'LIBRUBYARG' ]

task :default => :all

task :all => [ 'ext/malloc.so' ]

file 'ext/malloc.so' => OBJ do |t|
   sh "#{CXX} -shared -o #{t.name} #{OBJ} #{$RUBYLIB}"
   sh "#{STRIP} --strip-all #{t.name}"
end

Rake::PackageTask.new PKG_NAME, PKG_VERSION do |p|
  p.need_tar = true
  p.package_files = PKG_FILES
end

begin
  require 'rake/gempackagetask'
  spec = Gem::Specification.new do |s|
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
    s.test_files = TC
    # s.default_executable = %q{...}
    # s.executables = Dir.glob( 'bin/*' ).collect { |f| File.basename f }
    s.require_paths = [ 'lib', 'ext' ]
    s.rubyforge_project = %q{hornetseye}
    s.extensions = %w{Rakefile}
    s.autorequire = 'rake'
    s.has_rdoc = 'yard'
    s.extra_rdoc_files = []
    s.rdoc_options = %w{--no-private}
  end
  Rake::GemPackageTask.new spec do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
  end
rescue LoadError
end

Rake::TestTask.new do |t|
  t.libs << 'ext'
  t.test_files = TC
end

YARD::Rake::YardocTask.new :yard do |y|
  y.options << '--no-private'
  y.files << FileList[ 'lib/**/*.rb' ]
end

rule '.o' => '.cc' do |t|
   sh "#{CXX} #{$CXXFLAGS} -c -o #{t.name} #{t.source}"
end

file 'ext/error.o' => [ 'ext/error.cc', 'ext/error.hh' ]
file 'ext/malloc.o' => [ 'ext/malloc.cc', 'ext/malloc.hh', 'ext/error.hh' ]

CLEAN.include 'ext/*.o'
CLOBBER.include 'ext/malloc.so', 'doc'

