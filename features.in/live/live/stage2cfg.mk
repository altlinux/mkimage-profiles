# stage2 mod: livecd

IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(LIVE_PACKAGES) \
		 $(call map,list,$(LIVE_LISTS) $(LIVE_GROUPS)) \
		 interactivesystem

MKI_PACK_RESULTS = squash:live
