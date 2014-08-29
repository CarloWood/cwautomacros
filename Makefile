# Set the environment variable CWAUTOMACROSPREFIX to install cwautomacros
# in a custom directory. Note that this is just a prefix; all files will
# be installed in $CWAUTOMACROSPREFIX/share/cwautomacros.

ifeq (${CWAUTOMACROSPREFIX},)
# The default installation prefix.
INSTALLPREFIX = /usr
else
# Use installation prefix from environment if set and non-empty.
INSTALLPREFIX = ${CWAUTOMACROSPREFIX}
endif

LABEL := $(shell date +%Y%m%d)

all:
	@echo "Type 'make install' to install in $(INSTALLPREFIX)/share/cwautomacros."

install:
	install -d $(INSTALLPREFIX)/share/cwautomacros
	echo "$(LABEL)" > $(INSTALLPREFIX)/share/cwautomacros/version
	chmod 644 $(INSTALLPREFIX)/share/cwautomacros/version
	install -d $(INSTALLPREFIX)/share/cwautomacros/m4
	rm -f $(INSTALLPREFIX)/share/cwautomacros/m4/*.m4
	if test -e m4/CW_AUTOMACROS.m4.in; then \
	  cat m4/CW_AUTOMACROS.m4.in | sed -e 's/@VERSION@/$(LABEL)/' > m4/CW_AUTOMACROS.m4; \
	fi
	install -m 644 m4/*.m4 $(INSTALLPREFIX)/share/cwautomacros/m4
	install -d $(INSTALLPREFIX)/share/cwautomacros/scripts
	for scripts in `ls scripts/*.sh`; do \
	  sed -e 's^@INSTALLPREFIX@^$(INSTALLPREFIX)^g' $$scripts > $(INSTALLPREFIX)/share/cwautomacros/$$scripts; \
	  chmod 755 $(INSTALLPREFIX)/share/cwautomacros/$$scripts; \
	done
	install -d $(INSTALLPREFIX)/share/cwautomacros/templates
	install -m 755 templates/*.sh $(INSTALLPREFIX)/share/cwautomacros/templates
	install -d $(INSTALLPREFIX)/share/cwautomacros/templates/doxygen
	install -m 644 templates/doxygen/Makefile.am $(INSTALLPREFIX)/share/cwautomacros/templates/doxygen
	install -m 644 templates/doxygen/html.* $(INSTALLPREFIX)/share/cwautomacros/templates/doxygen
	install -m 644 templates/doxygen/*.css $(INSTALLPREFIX)/share/cwautomacros/templates/doxygen
	install -m 644 templates/doxygen/*.dox $(INSTALLPREFIX)/share/cwautomacros/templates/doxygen

