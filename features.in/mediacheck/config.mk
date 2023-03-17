ifeq (distro,$(IMAGE_CLASS))
use/mediacheck: use/stage2 sub/stage2@mediacheck \
	use/grub/mediacheck.cfg use/syslinux/mediacheck.cfg
	@$(call add_feature)
	@if ! command -v implantisomd5 >/dev/null 2>&1; then \
	    echo "Error: implantisomd5 is not available! Need install isomd5sum"; exit 1; \
	fi
	@$(call add,POSTPROCESS_TARGETS,90mediacheck)
else
use/mediacheck: ; @:
endif
