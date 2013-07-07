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
