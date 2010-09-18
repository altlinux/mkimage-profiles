include $(BUILDDIR)/.config.mk

ifndef BOOTLOADER
$(warning syslinux feature enabled but BOOTLOADER undefined)
endif

ifndef SYSLINUX_UI
$(warning no syslinux ui module configured, falling back to plain text prompt)
SYSLINUX_UI := prompt
endif

# UI is backed by modules in modern syslinux
# (except for built-in text prompt)
SYSLINUX_MODULES := $(SYSLINUX_MODULES) $(SYSLINUX_UI)

# SUBPROFILES are considered SYSLINUX_CFG too;
# 01defaults.cfg is included indefinitely
SYSLINUX_CFG := $(SYSLINUX_CFG) $(SUBPROFILES) defaults

DSTDIR := $(BUILDDIR)/stage1/files/syslinux
CONFIG := $(DSTDIR)/$(BOOTLOADER).cfg
MODDIR := /usr/lib/syslinux

# we can do SYSLINUX_{CFG,MODULES,FILES}
# CFG have only cfg snippet
# FILES have only filenames (absolute or relative to /usr/lib/syslinux/)
# MODULES must have both cfg snippet and syslinux module filename
#         (and get included iff cfg snippet AND module exist)

# syslinux modules come as .com and .c32 files
sysmod = $(wildcard $(addprefix $(MODDIR)/,$(addsuffix .c??,$(1))))
cfg = $(wildcard cfg.in/??$(1).cfg)

# NB: list position determined by file numbering (*.cfg sorting)
all: prep debug
	cat $(sort \
		$(foreach C,$(SYSLINUX_CFG),$(call cfg,$(C))) \
		$(foreach M,$(SYSLINUX_MODULES), \
			$(shell cp -pLt $(DSTDIR) -- $(call sysmod,$(M)) && echo $(call cfg,$(M))))) \
		/dev/null > $(CONFIG)
	[ -z "$(SYSLINUX_FILES)" ] || { \
		cd $(MODDIR); \
		cp -pLt $(DSTDIR) -- $(SYSLINUX_FILES); \
	}

# cat's argument gets evaluated before recipe body execution
prep:
	mkdir -p $(DSTDIR)

# for p in $...; do ls ??$p.cfg; done | sort
debug:
	@echo "** BOOTLOADER: $(BOOTLOADER)"
	@echo "** SYSLINUX_UI: $(SYSLINUX_UI)"
	@echo "** SYSLINUX_CFG: $(SYSLINUX_CFG)"
	@echo "** SYSLINUX_FILES: $(SYSLINUX_FILES)"
	@echo "** SYSLINUX_MODULES: $(SYSLINUX_MODULES)"
