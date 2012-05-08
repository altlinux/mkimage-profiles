CHROOT_PACKAGES += syslinux

postprocess-80isohybrid:
	@isohybrid "$(IMAGEDIR)/$(IMAGE_OUTFILE)"
