.SUFFIXES:
.SUFFIXES: .gem .o .cc .hh .rb .tar .gz .bz2

RUBY_VERSION = 1.8
MALLOC_VERSION = 0.1.6

CP = cp
RM = rm -f
MKDIR = mkdir -p
GEM = gem$(RUBY_VERSION)
RUBY = ruby$(RUBY_VERSION)
TAR = tar
GIT = git
SITELIBDIR = $(shell $(RUBY) -r mkmf -e "puts \"\#{Config::CONFIG['sitelibdir']}\"")
SITEARCHDIR = $(shell $(RUBY) -r mkmf -e "puts \"\#{Config::CONFIG['sitearchdir']}\"")

MAIN = Makefile source.gemspec binary.gemspec README COPYING
EXT = ext/extconf.rb $(wildcard ext/*.cc) $(wildcard ext/*.hh)
LIB = $(wildcard lib/*.rb)
TEST = $(wildcard test/*.rb)
DOC = $(wildcard doc/*.rb)
SOURCES = $(MAIN) $(EXT) $(LIB) $(TEST) $(DOC)

all:: target

target:: ext/malloc.so

gem:: malloc-$(MALLOC_VERSION).gem

binary-gem:: binary.gemspec ext/malloc.so $(LIB)
	$(GEM) build binary.gemspec

install:: ext/malloc.so $(LIB)
	$(MKDIR) $(SITELIBDIR)
	$(MKDIR) $(SITEARCHDIR)
	$(CP) $(LIB) $(SITELIBDIR)
	$(CP) ext/malloc.so $(SITEARCHDIR)

uninstall::
	$(RM) $(addprefix $(SITELIBDIR)/,$(notdir $(LIB)))
	$(RM) $(addprefix $(SITEARCHDIR)/,malloc.so)

install-gem:: malloc-$(MALLOC_VERSION).gem
	$(GEM) install $<

uninstall-gem::
	$(GEM) uninstall malloc || echo Nothing to uninstall

check:: ext/malloc.so $(LIB) $(TEST)
	$(RUBY) -Iext -Ilib $(TEST)

push-gem:: malloc-$(MALLOC_VERSION).gem
	echo Pushing $< in 3 seconds!
	sleep 3
	$(GEM) push $<

push-git::
	echo Pushing to origin in 3 seconds!
	sleep 3
	$(GIT) push origin master

dist:: dist-gzip

dist-gzip:: malloc-$(MALLOC_VERSION).tar.gz

dist-bzip2:: malloc-$(MALLOC_VERSION).tar.bz2

malloc-$(MALLOC_VERSION).gem: $(SOURCES)
	$(GEM) build source.gemspec

ext/Makefile: ext/extconf.rb
	cd ext && $(RUBY) extconf.rb && cd ..

ext/malloc.so: ext/Makefile $(EXT)
	cd ext && $(MAKE) && cd ..

malloc-$(MALLOC_VERSION).tar.gz: $(SOURCES)
	$(TAR) czf $@ $(SOURCES)

malloc-$(MALLOC_VERSION).tar.bz2: $(SOURCES)
	$(TAR) cjf $@ $(SOURCES)

clean::
	rm -f *~ ext/*~ ext/*.o ext/*.so ext/Makefile lib/*~ lib/*.so test/*~ doc/*~ *.gem

