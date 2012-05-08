CHROOT_PACKAGES += isomd5sum

postprocess-90isomd5sum:
	@implantisomd5 "$(IMAGEDIR)/$(IMAGE_OUTFILE)"
