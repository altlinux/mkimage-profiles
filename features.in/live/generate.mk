# set up livecd browser redirection page

ifdef BUILDDIR

include $(BUILDDIR)/distcfg.mk

ifndef HOMEPAGE
HOMEPAGE = http://altlinux.org/
endif

ifndef HOMENAME
HOMENAME = ALT
endif

ifndef HOMEWAIT
HOMEWAIT = 3
endif

INDEXHTML := $(BUILDDIR)/stage1/files/index.html

all: debug
	@if [ -s "$(INDEXHTML)" ]; then \
		sed -i \
			-e 's,@homepage@,$(HOMEPAGE),' \
			-e 's,@homename@,$(HOMENAME),' \
			-e 's,@homewait@,$(HOMEWAIT),' \
			$(INDEXHTML); \
	fi

debug:
	@if [ -n "$(DEBUG)" ]; then \
		echo "** HOMEPAGE: $(HOMEPAGE)"; \
		echo "** HOMENAME: $(HOMENAME)"; \
		echo "** HOMEWAIT: $(HOMEWAIT)"; \
	fi

endif
