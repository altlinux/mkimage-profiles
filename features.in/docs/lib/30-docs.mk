# step 4: build the distribution image

ifneq (,$(DOCS))
DOT_BASE += docs-$(DOCS)
CHROOT_PACKAGES += docs-$(DOCS)
endif

ifneq (,$(BRANDING))
CHROOT_PACKAGES_REGEXP += $(call branding,notes)
endif

CHROOT_PACKAGES_REGEXP += $(call branding,indexhtml)
