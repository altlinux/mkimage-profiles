# set up livecd browser redirection page

ifdef BUILDDIR

include $(BUILDDIR)/distcfg.mk

BOOTCHAIN_CFG := $(BUILDDIR)/stage1/files/bootchain

all: debug
	@if [ -n "$(META_VOL_ID)" ]; then \
		DISTRO="$(META_VOL_ID)"; \
	else \
		DISTRO="$(RELNAME)"; \
	fi; \
	if [ -s "$(BOOTCHAIN_CFG)" ]; then \
		sed -i \
			-e "s,@distro@,$$DISTRO," \
			$(BOOTCHAIN_CFG); \
	fi

debug:
	@if [ -n "$(DEBUG)" ]; then \
		echo "** DISTRO: $(DISTRO)"; \
	fi

endif
