# set up livecd browser redirection page

ifneq (,$(BUILDDIR))

include $(BUILDDIR)/distcfg.mk

ifeq (,$(HOMEPAGE))
HOMEPAGE = http://altlinux.org/
endif

ifeq (,$(HOMENAME))
HOMENAME = ALT
endif

ifeq (,$(HOMEWAIT))
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
