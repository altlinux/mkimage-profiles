# this makefile is designed to be included in toplevel one
ifdef BUILDDIR

# step 2: build up distribution's configuration

# NB: distro/ targets should be defined here,
# see toplevel Makefile's $(DISTRO) assignment
CONFIG = $(BUILDDIR)/.config.mk

# source initial feature snippets
-include features.in/*/config.mk

# put(), add(), set(), try(), tags(): see functions.mk
#
# package list names are considered relative to pkg/lists/
#
#  $(VAR) will be substituted before writing them to $(CONFIG);
# $$(VAR) will remain unsubstituted util $(CONFIG) is included
#         and their value requested (so the variable referenced
#         can change its value during configuration _before_
#         it's actually used)
#
# tags can do boolean expressions: (tag1 && !(tag2 || tag3))
include functions.mk

# request particular image subprofile inclusion
sub/%:
	@$(call add,SUBPROFILES,$(@:sub/%=%))

# initalize config from scratch, put some sane defaults in
distro/.init:
	@echo "** preparing distro configuration$${DEBUG:+: see $(CONFIG)}"
	@$(call try,MKIMAGE_PREFIX,/usr/share/mkimage)
	@$(call try,GLOBAL_VERBOSE,)
	@$(call try,IMAGEDIR,$(IMAGEDIR))
	@$(call try,IMAGENAME,$(IMAGENAME))

# NB: the last flavour in KFLAVOURS gets to be the default one;
# the kernel packages regexp evaluation has to take place at build stage
distro/.base: distro/.init sub/stage1 use/syslinux use/syslinux/localboot.cfg
	@$(call set,IMAGE_INIT_LIST,+branding-$$(BRANDING)-release)
	@$(call set,BRANDING,altlinux-sisyphus)
	@$(call set,KFLAVOURS,std-def)

distro/installer: distro/.base sub/install2 use/syslinux/install2.cfg
	@$(call set,INSTALLER,server-light)
	@$(call set,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,MAIN_PACKAGES,branding-$$(BRANDING)-release)
	@$(call set,BASE_LISTS,base)

distro/server-base: distro/installer sub/main use/syslinux/ui-menu use/memtest
	@$(call add,BASE_LISTS,server-base)

distro/server-light: distro/server-base use/hdt
	@$(call set,BRANDING,sisyphus-server-light)
	@$(call set,KFLAVOURS,ovz-el el-smp)	# override default
	@$(call add,KMODULES,igb ipset kvm ndiswrapper pf_ring rtl8192 xtables-addons)
	@$(call add,DISK_LISTS,kernel-wifi)
	@$(call add,BASE_LISTS,$(call tags,base server))
	@$(call add,GROUPS,dns-server http-server ftp-server kvm-server)
	@$(call add,GROUPS,ipmi mysql-server dhcp-server mail-server)
	@$(call add,GROUPS,monitoring diag-tools)

distro/minicd: distro/server-base
	@$(call set,KFLAVOURS,un-def)	# we might need the most recent drivers (NB: std-ng lacks aufs2)
	@$(call add,MAIN_PACKAGES,etcnet-full)

# bootloader test target
distro/syslinux: distro/.base use/syslinux/ui-gfxboot use/hdt use/memtest

# pick up release manager's config (TODO: distro-specific include as well?)
distro/.metaconf:
	@if [ -s $(HOME)/.mkimage/metaconf.mk ]; then \
		$(call put,-include $(HOME)/.mkimage/metaconf.mk); \
	fi

boot/%: distro/.init
	@$(call set,BOOTLOADER,$*)

endif
