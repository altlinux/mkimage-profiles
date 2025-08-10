ifeq (,$(filter-out e2k%,$(ARCH)))
use/e2k: use/tty/S0 use/l10n/default/ru_RU
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,blacklist-ide)	# avoid overwriting hda
	@$(call add,STAGE2_PACKAGES,agetty)
ifeq (,$(filter-out e2kv6 e2kv4,$(ARCH)))
	@# 1C+/2C3 specific
	@$(call add,SYSTEM_PACKAGES,softdep-mga2x)	# mcst#8089
endif
	@$(call add,SYSTEM_PACKAGES,softdep-i2c-mux)	# mcst#8627
	@$(call add,BASE_PACKAGES,mirror-e2k-alt)
	@$(call add,THE_PACKAGES,fruid_print)
	@$(call add,THE_PACKAGES,pwmd)
	@$(call add,DEFAULT_SERVICES_DISABLE,pwmd)
	@$(call add,DEFAULT_SERVICES_DISABLE,ModemManager)	# COM issues
	@$(call set,KFLAVOURS,elbrus-def)	# no other flavours for now
	@$(call set,REPO,http/ivk_e2k)	# the public origin
	@$(call set,LIVE_REPO,http/ivk_e2k)
	@$(call xport,STAGE2_BOOTARGS)

use/e2k/x11: use/e2k use/x11
	@$(call add,THE_PACKAGES,xorg-server xinit)
	@$(call add,INSTALL2_PACKAGES,xorg-drv-amdgpu lccrt-blobs)
	@$(call add,LIVE_PACKAGES,xorg-drv-amdgpu lccrt-blobs)

ifeq (,$(filter-out e2kv6,$(ARCH)))
use/e2k/multiseat/full:
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-multiseat)
	@$(call add,MAIN_GROUPS,x-e2k/90-e1601)
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/e1601-,1seat 4seat))
	@#$(call add,MAIN_GROUPS,x-e2k/90-e201)	# wait for GPU split on *201*
	@#$(call add,MAIN_GROUPS,$(addprefix x-e2k/e201-,1seat 2seat))
endif

ifeq (,$(filter-out e2kv5,$(ARCH)))
use/e2k/multiseat/full: use/e2k/multiseat/901/full; @:

# 6seat not tested so far but 1E8CB has three suitable PCIe slots
use/e2k/multiseat/901:
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-multiseat)
	@$(call add,MAIN_GROUPS,x-e2k/90-e901)
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e901-1seat e901-2seat))
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e901-3seat))

use/e2k/multiseat/901/full: use/e2k/multiseat/901 use/control
	@$(call add,MAIN_GROUPS,x-e2k/x-autologin)
	@$(call add,THE_PACKAGES,test-audio alterator-multiseat)
endif	# e2kv5

ifeq (,$(filter-out e2kv4,$(ARCH)))
use/e2k/multiseat/full: use/e2k/multiseat/801/full; @:

use/e2k/x11/101: use/e2k/x11; @:

use/e2k/multiseat/801/base:
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-multiseat)
	@$(call add,MAIN_GROUPS,x-e2k/90-e801)
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e801-1seat e801-2seat))

use/e2k/multiseat/801: use/e2k/multiseat/801/base
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e801-3seat e801-6seat))

use/e2k/multiseat/801/full: use/e2k/multiseat/801 use/control
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e801-2seat-4port))
	@$(call add,MAIN_GROUPS,$(addprefix x-e2k/,e801-3seat-4port))
	@$(call add,MAIN_GROUPS,x-e2k/x-autologin)
	@$(call add,THE_PACKAGES,test-audio alterator-multiseat)
else
use/e2k/x11/101: use/e2k/x11; @:
endif	# e2kv4

ifeq (,$(filter-out e2k,$(ARCH)))
use/e2k/multiseat/full:; @:
endif	# e2k(v3)

ifeq (,$(filter-out e2k,$(ARCH)))
use/e2k/sound/401:
	@$(call add,THE_PACKAGES,setup-alsa-elbrus-401)

else
use/e2k/sound/401:; @:
endif	# e2k
else
use/e2k:; @:
use/e2k/%:; @:
endif	# e2k%
