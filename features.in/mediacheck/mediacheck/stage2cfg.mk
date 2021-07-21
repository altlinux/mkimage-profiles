# stage2 mod: mediacheck single-purpose "live" image

IMAGE_PACKAGES = startup-mediacheck startup

MKI_PACK_RESULTS = squash:mediacheck

debug::
	@echo "** mediacheck: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
