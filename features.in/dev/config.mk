use/dev: use/control
	@$(call add_feature)
	@$(call add,THE_PACKAGES,git-core hasher gear)
	@$(call add,CONTROL,pam_mktemp:enabled)

# use/dev intentionally missing
use/dev/repo: use/repo/main
	@$(call add,THE_PACKAGES,apt-repo)
	@$(call add,MAIN_LISTS,$(call tags,main builder))

use/dev/mkimage: use/dev
	@$(call add,THE_PACKAGES,mkimage shadow-change su)

use/dev/builder/base: use/dev/mkimage
	@$(call add,THE_LISTS,$(call tags,builder && (base || extra)))

use/dev/builder/live: use/dev/builder/base
	@$(call add,LIVE_LISTS,$(call tags,live builder))
	@$(call add,LIVE_PACKAGES,livecd-qemu-arch qemu-user-binfmt_misc)

use/dev/builder/full: use/dev use/dev/builder/live use/dev/repo
	@$(call set,KFLAVOURS,$(BIGRAM))
	@$(call add,THE_LISTS,$(call tags,server extra))
	@$(call add,MAIN_LISTS,$(call tags,live builder))
ifeq (,$(filter-out i586 x86_64 ,$(ARCH)))
	@$(call add,MAIN_PACKAGES,syslinux memtest86+)
endif
	@$(call add,MAIN_PACKAGES,pciids xorriso)
	@$(call add,LIVE_PACKAGES,sudo perl-Gear-Remotes)

use/dev/groups/builder: use/dev/repo
	@$(call add,MAIN_GROUPS,dev/builder)
