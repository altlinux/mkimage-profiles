# stage2 mod: build install2 subprofile (installer "live" part)

IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 udev e2fsprogs glibc-nss

MKI_PACK_RESULTS = squash:altinst

debug:
	@echo "** install2: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** install2: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
