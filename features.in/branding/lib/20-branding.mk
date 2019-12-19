# step 4: build the distribution image

DOT_BASE += $(call branding,$(THE_BRANDING))

# needed for refind only
ifeq (,$(filter-out x86_64,$(ARCH)))
CHROOT_PACKAGES_REGEXP += $(call branding,bootloader)
CHROOT_PACKAGES += ImageMagick-tools
endif
