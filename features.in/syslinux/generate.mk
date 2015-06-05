ifdef BUILDDIR

# in deciseconds
DEFAULT_TIMEOUT = 90

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
$(warning no syslinux ui configured, default is now none)
SYSLINUX_UI := none
endif

ifndef SYSLINUX_DIRECT
# SUBPROFILES are considered SYSLINUX_CFG too
# (note these can appear like stage2@live);
# 01defaults.cfg is included indefinitely
SYSLINUX_CFG := $(SYSLINUX_CFG) $(SUBPROFILE_DIRS) defaults
endif

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

all: debug timeout
	@### proper text branding should be implemented
	@echo $(SYSLINUX_MODULES) > $(DSTDIR)/modules.list
	@echo $(SYSLINUX_FILES) > $(DSTDIR)/syslinux.list
	@sed -i \
		-e 's,@mkimage-profiles@,$(IMAGE_NAME),' \
		-e 's,@relname@,$(RELNAME),' \
		$(DSTDIR)/*.cfg

# integerity check
timeout: distro
	@if [ "$(SYSLINUX_TIMEOUT)" -ge 0 ] 2>/dev/null; then \
		TIMEOUT="$(SYSLINUX_TIMEOUT)"; \
	else \
		TIMEOUT="$(DEFAULT_TIMEOUT)"; \
	fi; \
	sed -i "s,@timeout@,$$TIMEOUT," $(DSTDIR)/*.cfg

distro: bootargs
	@if [ -n "$(META_VOL_SET)" ]; then \
		DISTRO="$(META_VOL_SET)"; \
	else \
		DISTRO="ALT Linux"; \
	fi; \
	sed -i "s,@distro@,$$DISTRO," $(DSTDIR)/*.cfg

# pass over additional parameters, if any
bootargs: clean
	@if [ -n "$(STAGE2_BOOTARGS)" ]; then \
		sed -i "s,@bootargs@,$(STAGE2_BOOTARGS)," $(DSTDIR)/*.cfg; \
	fi; \
	sed -i "s,@bootargs@,," $(DSTDIR)/*.cfg

clean: copy
	@if [ "$(SYSLINUX_UI)" = gfxboot ]; then \
		sed -i "s/\^//;/menu label /d" $(DSTDIR)/*.cfg; \
	fi

copy: prep
	@cp -pLt $(DSTDIR) -- $(sort \
		$(foreach C,$(SYSLINUX_CFG),$(call cfg,$(C))) \
		$(foreach M,$(SYSLINUX_MODULES),$(call cfg,$(M))))

prep:
	@mkdir -p $(DSTDIR)

debug:
	@if [ -n "$(DEBUG)" ]; then \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
		echo "** SYSLINUX_UI: $(SYSLINUX_UI)"; \
		echo "** SYSLINUX_CFG: $(SYSLINUX_CFG)"; \
		echo "** SYSLINUX_FILES: $(SYSLINUX_FILES)"; \
		echo "** SYSLINUX_MODULES: $(SYSLINUX_MODULES)"; \
	fi

endif
