# this makefile is designed to be included in toplevel one
ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

# step 2: build up distribution's configuration

# NB: distro/ targets should be defined in this file,
# see toplevel Makefile's $(DISTROS) assignment
CONFIG = $(BUILDDIR)/distcfg.mk

# collect use/% (source initial feature snippets)
-include features.in/*/config.mk

# put(), add(), set(), try(), tags():
# package list names are considered relative to pkg/lists/;
# tags can do boolean expressions: (tag1 && !(tag2 || tag3))
include functions.mk

# distro/.%, sub/.%, boot/%
include libdistro.mk

# bootloader test target; requires recent mkimage to build
distro/syslinux: distro/.init distro/.branding sub/stage1 \
	use/syslinux use/syslinux/localboot.cfg \
	use/syslinux/ui-vesamenu use/hdt use/memtest use/dos

#  $(VAR) will be substituted before writing them to $(CONFIG);
# $$(VAR) will remain unsubstituted util $(CONFIG) is included
#         and their value requested (so the variable referenced
#         can change its value during configuration _before_
#         it's actually used); just peek inside $(CONFIG) ;-)
# BASE_PACKAGES, BASE_LISTS, MAIN_PACKAGES, MAIN_LISTS: see sub.in/main/

# something actually useful (as a network-only installer)
distro/installer: distro/.base use/installer
	@$(call set,INSTALLER,altlinux-generic)
	@$(call set,INSTALLER_KMODULES_REGEXP,drm.*)	# for KMS

# server distributions

distro/server-base: distro/installer sub/main use/syslinux/ui-menu use/memtest
	@$(call add,BASE_LISTS,server-base)

distro/server-ovz: distro/server-base use/hdt use/firmware/server
	@$(call set,INSTALLER_KFLAVOUR,std-def)
	@$(call set,KFLAVOURS,std-def ovz-el)
	@$(call add,KMODULES,bcmwl e1000e igb ndiswrapper rtl8168 rtl8192)
	@$(call add,KMODULES,ipset ipt-netflow opendpi pf_ring xtables-addons)
	@$(call add,KMODULES,drbd83 kvm)
	@$(call add,MAIN_LISTS,kernel-wifi)
	@$(call add,BASE_LISTS,ovz-server)
	@$(call add,BASE_LISTS,$(call tags,base server))
	@$(call add,GROUPS,dns-server http-server ftp-server kvm-server)
	@$(call add,GROUPS,ipmi mysql-server dhcp-server mail-server)
	@$(call add,GROUPS,monitoring diag-tools)

distro/minicd: distro/server-base
	@$(call set,KFLAVOURS,pure-emerald)	# usually recent drivers
	@$(call add,MAIN_PACKAGES,etcnet-full)

# desktop distributions

distro/desktop-base: distro/installer sub/main \
	use/syslinux/ui-vesamenu use/x11/xorg

distro/icewm: distro/desktop-base use/lowmem use/x11/xdm use/x11/runlevel5
	@$(call add,BASE_LISTS,$(call tags,icewm desktop))

# NB: if there are too many screens above, it might make sense to distro.d/
