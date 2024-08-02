# stage2 mod: livecd

STAGE2_KMODULES = $(LIVE_KMODULES) $(THE_KMODULES)

IMAGE_PACKAGES_REGEXP = $(LIVE_PACKAGES_REGEXP) $(THE_PACKAGES_REGEXP)

IMAGE_PACKAGES = $(COMMON_PACKAGES) $(LIVE_PACKAGES) $(THE_PACKAGES) \
		 $(call map,list, \
			$(LIVE_LISTS) $(THE_LISTS) \
			$(call live_groups2lists) \
			$(COMMON_LISTS)) \
		 interactivesystem

MKI_PACK_RESULTS = squash:live

debug::
	@echo "** live: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** live: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
