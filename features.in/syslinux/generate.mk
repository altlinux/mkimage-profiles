ifdef BUILDDIR

# prepare data for syslinux installation;
# see also stage1/scripts.d/01-syslinux

include $(BUILDDIR)/distcfg.mk

ifndef BOOTLOADER
$(error syslinux feature enabled but BOOTLOADER undefined)
endif

# UI is backed by modules in modern syslinux
# (except for built-in text prompt)
ifdef SYSLINUX_UI
SYSLINUX_MODULES := $(SYSLINUX_MODULES) $(SYSLINUX_UI)
else
$(warning no syslinux ui configured, default is plain text prompt)
SYSLINUX_UI := prompt
endif

# SUBPROFILES are considered SYSLINUX_CFG too
# (note these can appear like stage2/live);
# 01defaults.cfg is included indefinitely
SYSLINUX_CFG := $(SYSLINUX_CFG) $(notdir $(SUBPROFILES)) defaults

### have to operate BUILDDIR, not pretty...
DSTDIR := $(BUILDDIR)/stage1/files/syslinux/.in

# we can do SYSLINUX_{CFG,MODULES,FILES}
# CFG have only cfg snippet
# FILES have only filenames (absolute or relative to /usr/lib/syslinux/)
# MODULES must have both cfg snippet and syslinux module filename
#         (and get included iff cfg snippet AND module exist)
cfg = $(wildcard cfg.in/??$(1).cfg)

# NB: list position determined by file numbering (*.cfg sorting)
#
# config snippets are copied into generated profile where they can
# be also tested against syslinux modules (some can be unavailable);
# we can't do tests right now since that implies host syslinux being
# identical to build system one which might be not the case...
#
# have to piggyback parameters as we're running in host system yet,
# and files involved will appear inside instrumental chroot
#
# arguments get evaluated before recipe body execution thus prep
all: prep debug
	@echo $(sort \
		$(foreach C,$(SYSLINUX_CFG),$(call cfg,$(C))) \
		$(foreach M,$(SYSLINUX_MODULES),$(call cfg,$(M)))) \
		| xargs cp -pLt $(DSTDIR) --
	@echo $(SYSLINUX_MODULES) > $(DSTDIR)/modules.list
	@echo $(SYSLINUX_FILES) > $(DSTDIR)/files.list
	@echo $(BOOTLOADER) > $(DSTDIR)/bootloader

prep:
	@mkdir -p $(DSTDIR)

debug:
	@if test -n "$(DEBUG)"; then \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
		echo "** SYSLINUX_UI: $(SYSLINUX_UI)"; \
		echo "** SYSLINUX_CFG: $(SYSLINUX_CFG)"; \
		echo "** SYSLINUX_FILES: $(SYSLINUX_FILES)"; \
		echo "** SYSLINUX_MODULES: $(SYSLINUX_MODULES)"; \
	fi

endif
