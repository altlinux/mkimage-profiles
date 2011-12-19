# stage2 mod: livecd

STAGE2_KMODULES = $(THE_KMODULES) $(LIVE_KMODULES)

IMAGE_PACKAGES = $(COMMON_PACKAGES) $(THE_PACKAGES) $(LIVE_PACKAGES) \
		 $(call map,list, \
			$(THE_LISTS) $(THE_GROUPS) \
			$(LIVE_LISTS) $(LIVE_GROUPS)) \
		 interactivesystem

MKI_PACK_RESULTS = squash:live
