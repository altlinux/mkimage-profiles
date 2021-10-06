ifeq (distro,$(IMAGE_CLASS))
use/mediacheck: use/stage2 sub/stage2@mediacheck \
	use/grub/mediacheck.cfg use/syslinux/mediacheck.cfg
	@$(call add_feature)
	@$(call add,POSTPROCESS_TARGETS,90mediacheck)
else
use/mediacheck: ; @:
endif
