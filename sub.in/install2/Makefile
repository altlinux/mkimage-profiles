# step 4: build install2 subprofile (installer "live" part)

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# kernel-modules only (but these require corresponding kernel-image)
IMAGE_PACKAGES_REGEXP = $(call kpackages)
IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 ./packages

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

# pass it to script hooks
ifneq "$(KDEFAULT)" ""
INFO_KDEFAULT := $(KDEFAULT)
else
INFO_KDEFAULT := $(lastword $(KFLAVOURS))
endif

all: build-image run-image-scripts run-scripts pack-image
