# stage2 mod: rescue "live" image

IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(RESCUE_PACKAGES) \
		 $(call list,$(RESCUE_LISTS)) \
		 interactivesystem startup-rescue

MKI_PACK_RESULTS = squash:rescue

debug::
	@echo "** rescue: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** rescue: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
