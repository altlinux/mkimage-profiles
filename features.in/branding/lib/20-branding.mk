# step 4: build the distribution image

DOT_BASE += $(call branding,$(THE_BRANDING))

CHROOT_PACKAGES_REGEXP += $(call branding,bootloader)
CHROOT_PACKAGES += ImageMagick-tools
