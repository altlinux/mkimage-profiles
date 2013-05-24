# stage2 mod: build install2 subprofile (installer "live" part)

ifndef INSTALLER
$(error install2 feature enabled but INSTALLER undefined)
endif

IMAGE_PACKAGES = $(INSTALL2_PACKAGES) \
		 udev e2fsprogs glibc-nss

MKI_PACK_RESULTS = squash:altinst

# also removed in a cleanup hook but to spare a few cycles...
HSH_EXCLUDE_DOCS = 1

debug::
	@echo "** install2: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** install2: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
	@echo "** install2: CLEANUP_PACKAGES: $(CLEANUP_PACKAGES)"
