IMAGE_PACKAGES_REGEXP += $(call branding, release \
	$(shell echo $(THE_BRANDING) $(STAGE2_BRANDING)|sed 's/bootloader//g'))
