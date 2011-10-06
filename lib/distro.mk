# step 2: build up distribution's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

# NB: distro/ targets should be defined in this file

DISTRO_TARGETS := $(shell sed -n 's,^\(distro/[^:.]\+\):.*$$,\1,p' \
		$(lastword $(MAKEFILE_LIST)) | sort)

ifeq (distro,$(IMAGE_CLASS))

.PHONY: $(DISTRO_TARGETS)

# request particular image subprofile inclusion
sub/%:
	@$(call add,SUBPROFILES,$(@:sub/%=%))

# install media bootloader
boot/%: profile/bare use/syslinux
	@$(call set,BOOTLOADER,$*)

# fundamental targets

distro/.init: profile/bare

# NB: the last flavour in KFLAVOURS gets to be the default one;
# the kernel packages regexp evaluation has to take place at build stage
distro/.base: distro/.init use/syslinux/localboot.cfg
	@$(call set,KFLAVOURS,std-def)

# bootloader test target
distro/syslinux: distro/.init \
	use/syslinux use/syslinux/localboot.cfg \
	use/syslinux/ui-vesamenu use/hdt use/memtest

# live images

distro/live: distro/.base use/live use/syslinux/ui-menu
distro/rescue: distro/.base use/rescue use/syslinux/ui-menu
distro/dos: distro/.init use/dos use/syslinux/ui-menu

#  $(VAR) will be substituted before writing them to $(CONFIG);
# $$(VAR) will remain unsubstituted until $(CONFIG) is included
#         and their value requested (so the variable referenced
#         can change its value during configuration _before_
#         it's actually used); just peek inside $(CONFIG) ;-)
# BASE_PACKAGES, BASE_LISTS, MAIN_PACKAGES, MAIN_LISTS: see sub.in/main/

# something actually useful (as a network-only installer)
# NB: doesn't carry stage3 thus cannot use/bootloader
distro/installer: distro/.base use/install2
	@$(call set,INSTALLER,altlinux-generic)
	@$(call set,STAGE1_KMODULES_REGEXP,drm.*)	# for KMS

# server distributions

distro/server-base: distro/installer sub/main \
	use/syslinux/ui-menu use/memtest use/bootloader/grub
	@$(call add,BASE_LISTS,server-base)

distro/server-mini: distro/server-base use/cleanup/x11-alterator
	@$(call set,KFLAVOURS,el-smp)
	@$(call add,KMODULES,e1000e igb)
	@$(call add,BASE_LISTS,\
		$(call tags,base && (server || network || security || pkg)))
	@$(call add,BASE_LISTS,$(call tags,extra network))

distro/server-ovz: distro/server-base \
	use/hdt use/rescue use/firmware/server use/powerbutton/acpi \
	use/cleanup/x11-alterator
	@$(call set,STAGE1_KFLAVOUR,std-def)
	@$(call set,KFLAVOURS,std-def ovz-el)
	@$(call add,KMODULES,bcmwl e1000e igb ndiswrapper rtl8168 rtl8192)
	@$(call add,KMODULES,ipset ipt-netflow opendpi pf_ring xtables-addons)
	@$(call add,KMODULES,drbd83 kvm)
	@$(call add,BASE_LISTS,ovz-server)
	@$(call add,BASE_LISTS,$(call tags,base server))
	@$(call add,MAIN_LISTS,kernel-wifi)
	@$(call add,MAIN_GROUPS,dns-server http-server ftp-server kvm-server)
	@$(call add,MAIN_GROUPS,ipmi mysql-server dhcp-server mail-server)
	@$(call add,MAIN_GROUPS,monitoring diag-tools)

# desktop distributions

distro/desktop-base: distro/installer sub/main \
	use/syslinux/ui-vesamenu use/x11/xorg use/bootloader/grub

distro/icewm: distro/desktop-base \
	use/lowmem use/x11/xdm use/x11/runlevel5 \
	use/bootloader/lilo use/powerbutton/acpi \
	use/cleanup/alterator
	@$(call add,BASE_LISTS,$(call tags,icewm desktop))

# NB: if there are too many screens above, it might make sense to distro.d/
endif
