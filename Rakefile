#!/usr/bin/env ruby
# This Rakefile is not completed yet.
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
require 'yard'

PGK_NAME = 'malloc'
PGK_VERSION = '0.2.3'
CXX = ENV[ 'CXX' ] || 'g++'
STRIP = ENV[ 'STRIP' ] || 'strip'
PKG_FILES = [ 'README', 'COPYING', '.document' ]
SRC = FileList[ 'ext/*.cc' ]
OBJ = SRC.ext 'o'

$CXXFLAGS = ENV[ 'CXXFLAGS' ] || ''

if Config::CONFIG[ 'rubyhdrdir' ]
  $CXXFLAGS += "#{$CXXFLAGS} -I#{Config::CONFIG[ 'rubyhdrdir' ]} " +
              "-I#{Config::CONFIG[ 'rubyhdrdir' ]}/#{Config::CONFIG[ 'arch' ]}"
else
  $CXXFLAGS += "#{$CXXFLAGS} -I#{Config::CONFIG[ 'archdir' ]}"
end
$RUBYLIB = Config::CONFIG[ 'LIBRUBYARG' ]

task :default => [ 'ext/malloc.so' ]

file 'ext/malloc.so' => OBJ do
   sh "#{CXX} -shared -o ext/malloc.so #{OBJ} #{$RUBYLIB}"
   sh "#{STRIP} --strip-all ext/malloc.so"
end

Rake::TestTask.new do |t|
  t.libs << 'ext'
  t.test_files = FileList[ 'test/tc_*.rb' ]
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

