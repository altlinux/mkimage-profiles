include $(BUILDDIR)/.config.mk

ifndef BOOTLOADER
$(warning syslinux feature enabled but BOOTLOADER undefined)
endif

ifndef SYSLINUX
SYSLINUX = textprompt
endif

### FIXME: too much insight (ab)used
DSTDIR := $(BUILDDIR)/stage1/files/syslinux
CONFIG := $(DSTDIR)/$(BOOTLOADER).cfg
PARTS  := $(SYSLINUX_UI) $(SYSLINUX_ITEMS) $(SUBPROFILES) timeout
MODDIR := /usr/lib/syslinux

# compile bootloader config from chosen parts
# NB: list position determined by file numbering (*.cfg)
config: debug copy
	@cat $(sort $(foreach P,$(PARTS),$(wildcard cfg.in/??$(P).cfg))) /dev/null > $(CONFIG)

prep:
	@mkdir -p $(DSTDIR)

# copy over the needed syslinux modules (item.c32 or item.com)
# and SYSLINUX_FILES (list of absolute paths)
copy: prep
	@$(foreach F, \
		$(SYSLINUX_FILES) $(wildcard $(addprefix $(MODDIR)/,$(addsuffix .c??,$(SYSLINUX_ITEMS)))), \
		$(shell cp -pLt $(DSTDIR) -- $(F)))

# for p in $PARTS; do ls ??$p.cfg; done | sort
debug:
	@echo "** BOOTLOADER: $(BOOTLOADER)"
	@echo "** SYSLINUX_UI: $(SYSLINUX_UI)"
	@echo "** SYSLINUX_ITEMS: $(SYSLINUX_ITEMS)"
	@echo "** PARTS: $(sort $(foreach P,$(PARTS),$(wildcard cfg.in/??$(P).cfg)))"
	@echo "** MODULES: $(wildcard $(addprefix $(MODDIR)/,$(addsuffix .c??,$(SYSLINUX_ITEMS))))"
