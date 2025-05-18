ifneq (,$(BUILDDIR))

# in seconds
DEFAULT_TIMEOUT = 60

# prepare data for grub installation;
# see also stage1/scripts.d/01-grub

include $(BUILDDIR)/distcfg.mk

ifeq (,$(BOOTLOADER))
$(error grub feature enabled but BOOTLOADER undefined)
endif

ifeq (,$(GRUB_DIRECT))
# SUBPROFILES are considered GRUB_CFG too
# (note these can appear like stage2@live);
# 01defaults.cfg is included indefinitely
GRUB_CFG := $(GRUB_CFG) defaults fwsetup_efi
endif

ifneq (,$(GRUB_UI))
GRUB_CFG := $(GRUB_CFG) gfxterm
endif

ifeq (,$(DISABLE_LANG_MENU))
ifneq (,$(LOCALES))
ifneq ($(words $(LOCALES)),1)
GRUB_CFG := $(GRUB_CFG) lang
endif
endif
endif

ifneq (,$(KFLAVOURS))
ifneq ($(words $(KFLAVOURS)),1)
GRUB_CFG := $(GRUB_CFG) kernel
endif
endif

DSTDIR  := $(BUILDDIR)/stage1/files/boot/grub/.in
DSTCFGS := $(DSTDIR)/*.cfg

# we can do GRUB_{CFG,MODULES,FILES}
# CFG have only cfg snippet
cfg = $(wildcard cfg.in/??$(1).cfg)

# NB: list position determined by file numbering (*.cfg sorting)
#
# config snippets are copied into generated profile where they can
# be also tested against grub modules (some can be unavailable);
# we can't do tests right now since that implies host grub being
# identical to build system one which might be not the case...
#
# have to piggyback parameters as we're running in host system yet,
# and files involved will appear inside instrumental chroot
#
# arguments get evaluated before recipe body execution thus prep

all: debug timeout
	@### proper text branding should be implemented
	@echo $(GRUB_FILES) > $(DSTDIR)/grub.list
	@sed -i \
		-e 's,@mkimage-profiles@,$(IMAGE_NAME),' \
		$(DSTCFGS)

# integerity check
timeout: distro
	@if [ "$(GRUB_TIMEOUT)" -ge 0 ] 2>/dev/null; then \
		TIMEOUT="$(GRUB_TIMEOUT)"; \
	else \
		TIMEOUT="$(DEFAULT_TIMEOUT)"; \
	fi; \
	sed -i "s,@timeout@,$$TIMEOUT," $(DSTCFGS)

distro: bootargs
	@if [ -n "$(META_VOL_ID)" ]; then \
		DISTRO="$(META_VOL_ID)"; \
	else \
		DISTRO="$(RELNAME)"; \
	fi; \
	sed -i "s,@distro@,$$DISTRO," $(DSTCFGS)

# pass over additional parameters, if any
bootargs: clean
	@if [ -n "$(STAGE2_BOOTARGS)" ]; then \
		sed -i "s,$(STAGE2_BOOTARGS),," $(DSTCFGS); \
		sed -i "s,@bootargs@,$(STAGE2_BOOTARGS)," $(DSTCFGS); \
	fi; \
	sed -i "s,@bootargs@,," $(DSTCFGS)
	@if [ -n "$(RESCUE_BOOTARGS)" ]; then \
		sed -i "s,@rescue_bootargs@,$(RESCUE_BOOTARGS)," $(DSTCFGS); \
	fi; \
	sed -i "s,@rescue_bootargs@,," $(DSTCFGS)
	@if [ -n "$(LOCALE)" ]; then \
		sed -i "s,@LOCALE@,$(LOCALE),g" $(DSTCFGS); \
	else \
		sed -i "s, lang=.lang,,g" $(DSTCFGS); \
	fi; \
	sed -i "/lang=@LOCALE@/d" $(DSTCFGS)
	@if [ -n "$(LOCALES)" ]; then \
		sed -i "s,@LOCALES@,$(LOCALES),g" $(DSTCFGS); \
	fi
	@GRUBTHEME=$(GRUBTHEME); \
	[ -n "$$GRUBTHEME" ] || GRUBTHEME=$$(cut -d "-" -f2 <<< $(BRANDING)); \
	sed -i "s,@grubtheme@,$$GRUBTHEME,g" $(DSTCFGS)
	@sed -i "s,@initrd@,initrd," $(DSTCFGS)
	@sed -i "s,@initrd_ext@,img," $(DSTCFGS)
	@sed -i "s|@initrd_bootmethod@|$(STAGE1_INITRD_BOOTMETHOD)|g" $(DSTCFGS)
	@sed -i "s|@initrd_typeargs@|$(STAGE1_INITRD_TYPEARGS)|g" $(DSTCFGS)
	@sed -i "s,@stagename@,$(STAGE1_INITRD_STAGE2_OPTION),g" $(DSTCFGS)
	@sed -i "s,@install2_init@,$(INSTALL2_INIT),g" $(DSTCFGS)
	@sed -i "s,@LIVE_NAME@,$(LIVE_NAME),g" $(DSTCFGS)
	@if [ -n "$(GLOBAL_TTY_DEV)" ] && [ -n "$(GLOBAL_TTY_RATE)" ]; then \
		sed -i "s,@serial_speed@,$(GLOBAL_TTY_RATE),g" $(DSTCFGS); \
		sed -i "s,@serial_port@,$(GLOBAL_TTY_DEV),g" $(DSTCFGS); \
		SERIAL_UNIT="`echo $(GLOBAL_TTY_DEV) |sed -r 's,^[^0-9]+,,'`"; \
		sed -i "s,@serial_unit@,$$SERIAL_UNIT,g" $(DSTCFGS); \
	else \
		sed -i "s, console=@serial_port@\,@serial_speed@n8 console=tty0,,g" $(DSTCFGS); \
	fi

clean: copy
	@if [ "$(GRUB_UI)" = gfxboot ]; then \
		sed -i "s/\^//;/menu label /d" $(DSTCFGS); \
	fi

copy: prep
	@cp -pLt $(DSTDIR) -- $(sort \
		$(foreach C,$(GRUB_CFG),$(call cfg,$(C))))

prep:
	@mkdir -p $(DSTDIR)

debug:
	@if [ -n "$(DEBUG)" ]; then \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
		echo "** GRUB_CFG: $(GRUB_CFG)"; \
		echo "** GRUB_FILES: $(GRUB_FILES)"; \
	fi

endif
