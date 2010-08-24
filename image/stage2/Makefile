CONFIGDIR = /usr/share/mkimage

include $(CONFIGDIR)/config.mk

IMAGE_PACKAGES = kernel-image-un-def \
		 udev \
		 e2fsprogs \
		 glibc-nss \
		 installer-distro-server-light-stage2

MKI_PACK_RESULTS = squash:altinst
#MKI_PACK_RESULTS = squash:live

include $(CONFIGDIR)/targets.mk

all: build-image run-image-scripts pack-image
