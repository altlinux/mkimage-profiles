# step 4: build the distribution image

ifneq (,$(DOCS))
DOT_BASE += docs-$(DOCS)
CHROOT_PACKAGES += docs-$(DOCS)
endif

ifneq (,$(findstring notes,$(THE_BRANDING) $(INSTALL2_BRANDING)))
CHROOT_PACKAGES_REGEXP += $(call branding,notes)
endif

ifneq (,$(findstring indexhtml,$(THE_BRANDING)))
CHROOT_PACKAGES_REGEXP += $(call branding,indexhtml)
endif
