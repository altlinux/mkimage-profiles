# alterator-based installer, second (livecd) stage

+live-installer: use/live-install/full; @:
+live-installer-pkg: use/live-install/full use/live-install/pkg; @:

use/live-install: use/live use/metadata use/repo/main \
	use/bootloader use/grub/live-install.cfg use/syslinux/live-install.cfg \
	use/alternatives/xvt/xterm
	@$(call add_feature)
	@$(call set,STAGE2_LIVE_INST,yes)
	@$(call try,MAIN_KERNEL_SAVE,no)
	@$(call xport,MAIN_KERNEL_SAVE)
	@$(call add,INSTALL2_PACKAGES,installer-common-stage2)
	@$(call add,THE_PACKAGES,alterator-wizardface)
	@$(call add,THE_LISTS,$(call tags,basesystem && !alterator))
	@$(call add,THE_PACKAGES,e2fsprogs mdadm lvm2 cryptsetup)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm make-initrd-lvm)
	@$(call add,BASE_PACKAGES,make-initrd-luks)
	@$(call add,INSTALL2_PACKAGES,$$(LIVE_INSTALL_PKG))
	@$(call add,THE_PACKAGES,alterator-postinstall) # for auto install
	@$(call add,INSTALL2_PACKAGES,xterm) # for vnc support
	@$(call try,INSTALLER,regular)	# might be replaced later
	@$(call add,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,THE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,BASE_PACKAGES,installer-distro-$$(INSTALLER)-stage3)
	@$(call add,INSTALL2_PACKAGES,glibc-gconv-modules) # for guile22
	@$(call add,INSTALL2_PACKAGES,curl) # for net install
	@$(call add,INSTALL2_PACKAGES,lsof) # for debug alterator-vm
	@$(call try,LIVE_INSTALL_PKG,installer-livecd-install)
	@$(call try,GLOBAL_LIVE_INSTALL,1)
	@$(call xport,BASE_BOOTLOADER)

use/live-install/full: use/live-install \
	use/syslinux/localboot.cfg use/grub/localboot_bios.cfg \
	use/syslinux/ui/menu; @:

use/live-install/pkg: use/live-install
	@$(call set,LIVE_INSTALL_PKG,)
	@$(call set,GLOBAL_LIVE_INSTALL,)

ifneq (,$(filter-out p10,$(BRANCH)))
use/live-install/desktop: use/live-install
	@$(call add,INSTALL2_PACKAGES,installer-common-desktop)
	@$(call add,BASE_PACKAGES,installer-alterator-livecd-stage3)
else
use/live-install/desktop: use/live-install; @:
endif

# set up remote repositories within installed system out-of-box
use/live-install/repo: use/live-install; @:
	@$(call add,INSTALL2_PACKAGES,installer-feature-online-repo)

# this one expects external vncviewer to come
use/live-install/vnc/listen: use/live-install \
	use/syslinux/live-install-vnc-listen.cfg use/grub/live-install-vnc-listen.cfg; @:

# this one connects to a specified vncviewer --listen
use/live-install/vnc/connect: use/live-install \
	use/syslinux/live-install-vnc-connect.cfg use/grub/live-install-vnc-connect.cfg; @:

# add both bootloader items to be *that* explicit ;-)
use/live-install/vnc/full: use/live-install/vnc/listen use/live-install/vnc/connect; @:

# prepare bootloader for software suspend (see also live)
use/live-install/suspend:
	@$(call add,BASE_PACKAGES,installer-feature-desktop-suspend-stage2)

use/live-install/oem: use/live-install
	@$(call add,INSTALL2_PACKAGES,installer-feature-oem-stage2)
	@$(call add,MAIN_PACKAGES,alterator-setup)
	@$(call add,MAIN_PACKAGES,installer-feature-alterator-setup-stage2)
