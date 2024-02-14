# alterator-based installer, second (livecd) stage

+live-installer: use/live-install/full; @:
+live-installer-pkg: use/live-install/full use/live-install/pkg; @:

use/live-install: use/live use/metadata use/repo/main \
	use/bootloader use/grub/live-install.cfg use/syslinux/live-install.cfg \
	use/alternatives/xvt/xterm
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,installer-common-stage2)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
	@$(call add,THE_LISTS,$(call tags,basesystem && !alterator))
	@$(call add,LIVE_PACKAGES,$$(LIVE_INSTALL_PKG))
	@$(call add,THE_PACKAGES,alterator-postinstall) # for auto install
	@$(call add,LIVE_PACKAGES,xterm) # for vnc support
	@$(call try,INSTALLER,regular)	# might be replaced later
	@$(call add,LIVE_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,THE_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,THE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,THE_PACKAGES,installer-distro-$$(INSTALLER)-stage3)
	@$(call add,LIVE_PACKAGES,glibc-gconv-modules) # for guile22
	@$(call add,LIVE_PACKAGES,curl) # for net install
	@$(call add,LIVE_PACKAGES,lsof) # for debug alterator-vm
	@$(call try,LIVE_INSTALL_PKG,installer-livecd-install)
	@$(call try,GLOBAL_LIVE_INSTALL,1)
	@$(call xport,BASE_BOOTLOADER)

use/live-install/full: use/live-install \
	use/syslinux/localboot.cfg use/grub/localboot_bios.cfg \
	use/syslinux/ui/menu; @:

use/live-install/pkg: use/live-install
	@$(call set,LIVE_INSTALL_PKG,)
	@$(call set,GLOBAL_LIVE_INSTALL,)

# set up remote repositories within installed system out-of-box
use/live-install/repo: use/live-install; @:
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,LIVE_PACKAGES,installer-feature-online-repo)
endif

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
	@$(call add,LIVE_PACKAGES,installer-feature-oem-stage2)
	@$(call add,MAIN_PACKAGES,alterator-setup)
	@$(call add,MAIN_PACKAGES,installer-feature-alterator-setup-stage2)
