use/dev: use/control
	@$(call add_feature)
	@$(call add,THE_PACKAGES,git-core hasher gear)
	@$(call add,CONTROL,pam_mktemp:enabled)

use/dev/mkimage: use/dev
	@$(call add,THE_PACKAGES,mkimage shadow-change su)

use/dev/repo: use/dev use/repo/main
	@$(call add,THE_PACKAGES,apt-repo)
	@$(call add,MAIN_PACKAGES,rpm-build basesystem)
	@$(call add,MAIN_PACKAGES,fakeroot sisyphus_check)
	@$(call add,MAIN_PACKAGES,file make-initrd make-initrd-propagator)

use/dev/builder/base: use/dev/mkimage use/dev
	@$(call set,KFLAVOURS,$(BIGRAM))
	@$(call add,LIVE_LISTS,\
		$(call tags,(base || live) && (server || builder)))
	@$(call add,LIVE_PACKAGES,livecd-qemu-arch strace)
	@$(call add,LIVE_PACKAGES,qemu-user-binfmt_misc)

use/dev/builder/full: use/dev/builder/base use/dev/repo
	@$(call add,MAIN_LISTS,$(call tags,live builder))
	@$(call add,MAIN_PACKAGES,syslinux pciids memtest86+ xorriso)
	@$(call add,LIVE_PACKAGES,sudo)
