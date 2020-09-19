use/e2k: use/tty/S0 use/l10n/default/ru_RU
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
	@$(call add,BASE_PACKAGES,mirror-e2k-alt)
	@$(call add,THE_PACKAGES,pwmd)
	@$(call add,DEFAULT_SERVICES_DISABLE,pwmd)
	@$(call set,KFLAVOURS,elbrus-def)	# no other flavours for now
	@$(call xport,STAGE2_BOOTARGS)

use/e2k/x11: use/e2k use/x11
	@$(call add,THE_PACKAGES,xorg-server xinit)

ifeq (,$(filter-out e2kv4,$(ARCH)))
use/e2k/x11/101: use/e2k/x11
	@$(call add,MAIN_GROUPS,x-e2k/91-e101)
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e101-modesetting))

use/e2k/multiseat/801/base:
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-801-multiseat)
	@$(call add,MAIN_GROUPS,x-e2k/90-e801)
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e801-1seat e801-2seat))

use/e2k/multiseat/801: use/e2k/multiseat/801/base
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e801-3seat e801-6seat))

use/e2k/multiseat/801/full: use/e2k/multiseat/801 use/control
	@$(call add,MAIN_GROUPS,x-e2k/x-autologin)
	@$(call add,THE_PACKAGES,test-audio)
	@$(call add,CONTROL,udisks2:shared)     ### media mount exclusivity
else
use/e2k/x11/101:; @:
use/e2k/multiseat/801/base use/e2k/multiseat/801 use/e2k/multiseat/801/full:; @:
endif	# e2kv4

ifeq (,$(filter-out e2k,$(ARCH)))
use/e2k/sound/401:
	@$(call add,THE_PACKAGES,setup-alsa-elbrus-401)

else
use/e2k/sound/401:; @:
endif	# e2k
