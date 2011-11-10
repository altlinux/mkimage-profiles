CHROOT_PACKAGES += isomd5sum

postprocess-isomd5sum:
	@implantisomd5 "$(IMAGEDIR)/$(IMAGE_OUTFILE)"
