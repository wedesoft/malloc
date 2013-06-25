#!/usr/bin/env ruby
require 'date'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/loaders/makefile'
require 'rbconfig'

SPEC = eval File.read('malloc.gemspec')

PKG_NAME = SPEC.name
PKG_VERSION = SPEC.version
CFG = RbConfig::CONFIG
CXX = ENV[ 'CXX' ] || 'g++'
RB_FILES = FileList['lib/**/*.rb']
CC_FILES = FileList['ext/*.cc']
TC_FILES = FileList['test/tc_*.rb']
SO_FILE = "ext/#{PKG_NAME.tr '\-', '_'}.#{CFG[ 'DLEXT' ]}"
PKG_FILES = SPEC.files
AUTHOR = SPEC.author
EMAIL = SPEC.email

OBJ = CC_FILES.ext 'o'
$CXXFLAGS = "-DNDEBUG #{CFG[ 'CPPFLAGS' ]} #{CFG[ 'CFLAGS' ]}"
if CFG[ 'rubyhdrdir' ]
  $CXXFLAGS = "#{$CXXFLAGS} -I#{CFG[ 'rubyhdrdir' ]} " + 
              "-I#{CFG[ 'rubyhdrdir' ]}/#{CFG[ 'arch' ]}"
else
  $CXXFLAGS = "#{$CXXFLAGS} -I#{CFG[ 'archdir' ]}"
end
$LIBRUBYARG = "-L#{CFG[ 'libdir' ]} #{CFG[ 'LIBRUBYARG' ]} #{CFG[ 'LDFLAGS' ]} " +
              "#{CFG[ 'SOLIBS' ]} #{CFG[ 'DLDLIBS' ]}"
$SITELIBDIR = CFG[ 'sitelibdir' ]
$SITEARCHDIR = CFG[ 'sitearchdir' ]
$LDSHARED = CFG[ 'LDSHARED' ][ CFG[ 'LDSHARED' ].index( ' ' ) .. -1 ]

task :default => :all

desc 'Compile Ruby extension (default)'
task :all => [ SO_FILE ]

file SO_FILE => OBJ do |t|
   sh "#{CXX} #{$LDSHARED} -o #{t.name} #{OBJ} #{$LIBRUBYARG}"
end

task :test => [ SO_FILE ]

desc 'Build RubyGem'
task :build do
  system "gem build #{PKG_NAME}.gemspec"
end

desc 'Install Ruby extension'
task :install => :all do
  verbose true do
    for f in RB_FILES do
      FileUtils.mkdir_p "#{$SITELIBDIR}/#{File.dirname f.gsub( /^lib\//, '' )}"
      FileUtils.cp_r f, "#{$SITELIBDIR}/#{f.gsub( /^lib\//, '' )}"
    end
    FileUtils.mkdir_p $SITEARCHDIR
    FileUtils.cp SO_FILE, "#{$SITEARCHDIR}/#{File.basename SO_FILE}"
  end
end

desc 'Uninstall Ruby extension'
task :uninstall do
  verbose true do
    for f in RB_FILES do
      FileUtils.rm_f "#{$SITELIBDIR}/#{f.gsub /^lib\//, ''}"
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
    y.files << RB_FILES
  end
rescue LoadError
  STDERR.puts 'Please install \'yard\' if you want to generate documentation'
end

begin
  require 'fpm'
  desc 'Create Debian package'
  task :deb => :gem do
    system "fpm -f -s gem -t deb -n #{PKG_NAME} -m '#{AUTHOR} <#{EMAIL}>' " +
           "--deb-priority optional -d ruby1.9.1 " +
           "pkg/#{PKG_NAME}-#{PKG_VERSION}.gem"
  end
rescue LoadError
  STDERR.puts 'Please install \'fpm\' if you want to create Debian packages'
end

Rake::PackageTask.new PKG_NAME, PKG_VERSION do |p|
  p.need_tar = true
  p.package_files = PKG_FILES
end

rule '.o' => '.cc' do |t|
   sh "#{CXX} #{$CXXFLAGS} -c -o #{t.name} #{t.source}"
end

file ".depends.mf" do |t|
  sh "g++ -MM #{CC_FILES.join ' '} | " +
    "sed -e :a -e N -e 's/\\n/\\$/g' -e ta | " +
    "sed -e 's/ *\\\\\\$ */ /g' -e 's/\\$/\\n/g' | sed -e 's/^/ext\\//' > #{t.name}"
end
CC_FILES.each do |t|
  file t.ext(".o") => t
end
import ".depends.mf"

CLEAN.include 'ext/*.o'
CLOBBER.include SO_FILE, 'doc', '.yardoc', '.depends.mf'
