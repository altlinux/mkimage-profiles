CHROOT_PACKAGES += isomd5sum

postprocess-90mediacheck:
	@implantisomd5 "$(IMAGEDIR)/$(IMAGE_OUTFILE)"
