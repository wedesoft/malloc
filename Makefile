.SILENT:
.SUFFIXES:
.SUFFIXES: .gem .o .cc .hh .rb .tar .gz .bz2

RUBY_VERSION = 1.8
MALLOC_VERSION = 0.1.6

GEM = gem$(RUBY_VERSION)
RUBY = ruby$(RUBY_VERSION)
TAR = tar

MAIN = Makefile malloc.gemspec binary.gemspec README COPYING
EXT = ext/extconf.rb $(wildcard ext/*.cc) $(wildcard ext/*.hh)
LIB = $(wildcard lib/*.rb)
TESTS = $(wildcard test/*.rb)
DOC = $(wildcard doc/*.rb)
SOURCES = $(MAIN) $(EXT) $(LIB) $(TESTS) $(DOC)

all:: malloc-$(MALLOC_VERSION).gem

check:: ext/malloc.so $(LIB) $(TESTS)
	$(RUBY) -Iext -Ilib $(TESTS)

binary:: binary.gemspec ext/malloc.so $(LIB)
	$(GEM) build binary.gemspec

install:: malloc-$(MALLOC_VERSION).gem
	$(GEM) install $<

push:: malloc-$(MALLOC_VERSION).gem
	echo Pushing $< in 3 seconds!
	sleep 3
	$(GEM) push $<

uninstall::
	$(GEM) uninstall malloc || echo Nothing to uninstall

dist:: malloc.tar.gz

dist-gzip:: malloc.tar.gz

dist-bzip2:: malloc.tar.bz2

malloc-$(MALLOC_VERSION).gem: malloc.gemspec README $(EXT) $(LIB) $(TESTS) $(DOC)
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
	rm -f *~ ext/*~ ext/*.o ext/*.so ext/Makefile lib/*~ lib/*.so test/*~ doc/*~ *.gem
