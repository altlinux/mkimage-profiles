# alterator-based installer, second (livecd) stage

+live-installer: use/live-install/full; @:

use/live-install: use/live use/metadata use/repo/main \
	use/bootloader use/grub/live-install.cfg use/syslinux/live-install.cfg
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,installer-common-stage2)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
	@$(call add,LIVE_PACKAGES,installer-livecd-install)
	@$(call add,LIVE_PACKAGES,alterator-postinstall) # for auto install
	@$(call try,INSTALLER,altlinux-generic)	# might be replaced later
	@$(call add,LIVE_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,LIVE_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,LIVE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,LIVE_PACKAGES,installer-distro-$$(INSTALLER)-stage3)
	@$(call add,LIVE_PACKAGES,glibc-gconv-modules) # for guile22
	@$(call add,LIVE_PACKAGES,curl) # for net install
	@$(call add,LIVE_PACKAGES,lsof) # for debug alterator-vm
	@$(call set,GLOBAL_LIVE_INSTALL,1)
	@$(call xport,BASE_BOOTLOADER)

use/live-install/full: use/live-install \
	use/syslinux/localboot.cfg use/grub/localboot_bios.cfg \
	use/syslinux/ui/menu; @:

# set up remote repositories within installed system out-of-box
use/live-install/repo: use/live-install; @:
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,BASE_PACKAGES,installer-feature-online-repo)
endif

use/live-install/vnc:
	@$(call add,LIVE_PACKAGES,installer-feature-vnc-stage2)

# this one expects external vncviewer to come
use/live-install/vnc/listen: use/live-install/vnc \
	use/syslinux/live-install-vnc-listen.cfg use/grub/live-install-vnc-listen.cfg; @:

# this one connects to a specified vncviewer --listen
use/live-install/vnc/connect: use/live-install/vnc \
	use/syslinux/live-install-vnc-connect.cfg use/grub/live-install-vnc-connect.cfg; @:

# add both bootloader items to be *that* explicit ;-)
use/live-install/vnc/full: use/live-install/vnc/listen use/live-install/vnc/connect; @:

# prepare bootloader for software suspend (see also live)
use/live-install/suspend:
	@$(call add,BASE_PACKAGES,installer-feature-desktop-suspend-stage2)
