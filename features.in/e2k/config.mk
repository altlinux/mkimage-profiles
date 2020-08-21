use/e2k: use/tty/S0
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,installer-feature-e2k-fix-clock-stage3)
	@$(call add,LIVE_PACKAGES,installer-feature-e2k-fix-boot-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-e2k-ignore-cf-stage2)
	@$(call add,LIVE_PACKAGES,livecd-installer-features)
	@$(call add,LIVE_PACKAGES,blacklist-ide)	# avoid overwriting hda
	@$(call add,STAGE2_PACKAGES,agetty)
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-xorg-conf-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-fix-boot-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-fstrim-stage2)
	@$(call add,INSTALL2_PACKAGES,blacklist-ide)	# avoid overwriting hda
	@$(call add,INSTALL2_PACKAGES,ifplugd)	# for net-eth link status
	@$(call add,INSTALL2_CLEANUP_PACKAGES,llvm)
	@$(call set,KFLAVOURS,elbrus-def)	# no other flavours for now
	@$(call xport,STAGE2_BOOTARGS)

use/e2k/x11: use/e2k use/x11
	@$(call add,THE_PACKAGES,xorg-server xinit)

use/e2k/sound/401:
	@$(call add,THE_PACKAGES,setup-alsa-elbrus-401)
