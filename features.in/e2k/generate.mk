ifneq (,$(BUILDDIR))

# prepare boot.conf

include $(BUILDDIR)/distcfg.mk

DSTDIR  := $(BUILDDIR)/stage1/files
RESULTCFG := $(DSTDIR)/boot.conf

all: debug prep config timeout

# integrity check
timeout: config
	@TIMEOUT=3; \
	sed -i "s,@timeout@,$$TIMEOUT," $(RESULTCFG)

config: prep
	@mv $(DSTDIR)/head.conf $(RESULTCFG); \
	DEFAULT=""; \
	MENU_ITEMS=""; \
	error() { echo "Error: $$@" >&2; exit 1; }; \
	[ -n "$(STAGE2_ALTINST)" ] && [ -n "$(STAGE2_LIVE_INST)" ] && \
		error "both STAGE2_ALTINST and STAGE2_LIVE_INST set"; \
	[ -n "$(STAGE2_RESCUE)" ] && [ -n "$(STAGE2_LIVE_RESCUE)" ] && \
		error "both STAGE2_RESCUE and STAGE2_LIVE_RESCUE set"; \
	[ -z "$(STAGE2_ALTINST)" ] || \
		MENU_ITEMS="altinst"; \
	[ -z "$(STAGE2_LIVE_INST)" ] || \
		MENU_ITEMS="$$MENU_ITEMS liveinst"; \
	[ -z "$(STAGE2_LIVE)" ] || \
		MENU_ITEMS="$$MENU_ITEMS live"; \
	[ -z "$(STAGE2_LIVE_RESCUE)" ] || \
		MENU_ITEMS="$$MENU_ITEMS liverescue"; \
	[ -z "$(STAGE2_RESCUE)" ] || \
		MENU_ITEMS="$$MENU_ITEMS rescue"; \
	for i in $$MENU_ITEMS; do \
		if [ "$$i" = altinst ]; then \
			LABEL="install"; \
			STAGE2="stagename=altinst"; \
			INIT=""; \
		elif [ "$$i" = liveinst ]; then \
			LABEL="install"; \
			STAGE2="stagename=live"; \
			INIT=" $(INSTALL2_INIT)"; \
		elif [ "$$i" = liverescue ]; then \
			LABEL=rescue; \
			STAGE2="stagename=live"; \
			INIT=" systemd.unit=live-rescue.target"; \
		else \
			LABEL="$$i"; \
			STAGE2="stagename=$$i"; \
			INIT=""; \
		fi; \
		[ -n "$$DEFAULT" ] || DEFAULT="$$LABEL"; \
		sed -e "s,@stage2@,$$STAGE2$$INIT," \
		    -e "s,@label@,$$LABEL," \
			< $(DSTDIR)/body.conf \
			> $(DSTDIR)/temp.conf; \
		if [ "$$i" = rescue ] || [ "$$i" = liverescue ]; then \
			sed -i "s;@stage2_bootargs@;nosplash $(RESCUE_BOOTARGS);" $(DSTDIR)/temp.conf; \
		fi; \
		cat $(DSTDIR)/temp.conf >> $(RESULTCFG); \
		rm $(DSTDIR)/temp.conf; \
	done; \
	sed -i "s,@default@,$$DEFAULT," $(RESULTCFG); \
	sed -i "s,@lang@,lang=$(LOCALE)," $(RESULTCFG); \
	sed -i "s;@initrd_typeargs@;$(STAGE1_INITRD_TYPEARGS);" $(RESULTCFG); \
	sed -i "s;@stage2_bootargs@;$(STAGE2_BOOTARGS);" $(RESULTCFG); \
	rm -f $(DSTDIR)/body.conf

clean:
	@rm -f $(RESULTCFG)

prep:
	@mkdir -p $(DSTDIR)
	@cp cfg.in/{body,head}.conf $(DSTDIR)/

debug:
	@if [ -n "$(DEBUG)" ]; then \
		[ -z "$(STAGE2_ALTINST)" ] || \
			echo "** STAGE2_ALTINST: $(STAGE2_ALTINST)"; \
		[ -z "$(STAGE2_LIVE)" ] || \
			echo "** LIVE: $(STAGE2_LIVE)"; \
		[ -z "$(STAGE2_LIVE_INST)" ] || \
			echo "** LIVE_INST: $(STAGE2_LIVE_INST)"; \
		[ -z "$(STAGE2_LIVE_RESCUE)" ] || \
			echo "** LIVE_RESCUE: $(STAGE2_LIVE_RESCUE)"; \
		[ -z "$(STAGE2_RESCUE)" ] || \
			echo "** RESCUE: $(STAGE2_RESCUE)"; \
	fi

endif
