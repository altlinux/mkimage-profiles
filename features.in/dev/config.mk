use/dev: use/control
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,git-core hasher gear)
	@$(call add,CONTROL,pam_mktemp:enabled)
	@$(call add,DEFAULT_SERVICES_ENABLE,hasher-privd)

# use/dev intentionally missing
use/dev/repo: use/repo/main
	@$(call add,BASE_PACKAGES,apt-repo)
	@$(call add,MAIN_LISTS,$(call tags,main builder))
	@$(call try,DEV_REPO,1)

use/dev/mkimage: use/dev
	@$(call add,BASE_PACKAGES,mkimage shadow-change su)

use/dev/builder/base: use/dev/mkimage
	@$(call add,BASE_LISTS,$(call tags,builder && (base || extra)))

use/dev/builder/live: use/dev
	@$(call add,LIVE_LISTS,$(call tags,live builder))
	@$(call add,LIVE_LISTS,$(call tags,builder && (base || extra)))
	@$(call add,LIVE_PACKAGES,git-core hasher gear)
	@$(call add,LIVE_PACKAGES,mkimage shadow-change su)
	@$(call add,LIVE_PACKAGES,apt-repo)

use/dev/builder/live/sysv: use/dev/builder/live; @:
ifeq (,$(filter-out x86_64 ,$(ARCH)))
	@$(call add,LIVE_PACKAGES,livecd-qemu-arch qemu-user-binfmt_misc)
endif

use/dev/builder/live/systemd: use/dev/builder/live use/net-eth/networkd-dhcp \
	use/net/networkd/resolved
	@$(call add,LIVE_PACKAGES,systemd-settings-disable-kill-user-processes)
ifeq (,$(filter-out x86_64 ,$(ARCH)))
	@$(call add,LIVE_PACKAGES,qemu-user-static-binfmt)
	@$(call add,DEFAULT_SERVICES_ENABLE,systemd-binfmt)
endif

use/dev/builder/full: use/dev use/dev/builder/live use/dev/repo
ifneq (,$(BIGRAM))
	@$(call set,KFLAVOURS,$(BIGRAM))
endif
	@$(call add,THE_LISTS,$(call tags,server extra))
	@$(call add,MAIN_LISTS,$(call tags,live builder))
ifeq (,$(filter-out i586 x86_64 ,$(ARCH)))
	@$(call add,MAIN_PACKAGES,syslinux memtest86+)
endif
	@$(call add,MAIN_PACKAGES,pciids xorriso)
	@$(call add,LIVE_PACKAGES,sudo perl-Gear-Remotes)

use/dev/groups/builder: use/dev/repo
	@$(call add,MAIN_GROUPS,dev/builder)
	@$(call set,DEV_REPO,)
