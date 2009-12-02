.SUFFIXES:
.SUFFIXES: .gem .o .cc .hh .rb .tar .gz .bz2

RUBY_VERSION = 1.8
GEM_VERSION = 0.1.0

GEM = gem$(RUBY_VERSION)
RUBY = ruby$(RUBY_VERSION)
TAR = tar
TEST = -t

MAIN = Makefile malloc.gemspec README COPYING
EXT = ext/extconf.rb $(wildcard ext/*.cc) $(wildcard ext/*.hh)
LIB = $(wildcard lib/*.rb)
TESTS = $(wildcard tests/*.rb)
DOC = $(wildcard doc/*.rb)
SOURCES = $(MAIN) $(EXT) $(LIB) $(TESTS) $(DOC)

all:: malloc-$(GEM_VERSION)-x86-linux.gem

check:: ext/malloc.so $(LIB) $(TESTS)
	$(RUBY) -Iext -Ilib $(TESTS)

install:: malloc-$(GEM_VERSION)-x86-linux.gem
	$(GEM) install $(TEST) $<

uninstall::
	$(GEM) uninstall malloc || echo Nothing to uninstall

dist:: malloc.tar.gz

dist-gzip:: malloc.tar.gz

dist-bzip2:: malloc.tar.bz2

malloc-$(GEM_VERSION)-x86-linux.gem: malloc.gemspec README $(EXT) $(LIB) $(TESTS) $(DOC)
	$(GEM) build malloc.gemspec

ext/Makefile: ext/extconf.rb
	cd ext && $(RUBY) extconf.rb && cd ..

ext/malloc.so: ext/Makefile $(EXT)
	cd ext && $(MAKE) && cd ..

malloc.tar.gz: $(SOURCES)
	$(TAR) czf $@ $(SOURCES)

malloc.tar.bz2: $(SOURCES)
	$(TAR) cjf $@ $(SOURCES)

clean::
	rm -f *~ ext/*~ ext/*.o ext/*.so ext/Makefile lib/*~ lib/*.so tests/*~ doc/*~ *.gem
