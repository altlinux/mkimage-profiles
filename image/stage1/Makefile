include /usr/share/mkimage/config.mk

GLOBAL_VERBOSE=1

#CHROOT_PACKAGES=kernel-image-un-def
CHROOT_PACKAGES = kernel-image-un-def apt-utils

#SUBDIR = /boot
MKI_IMAGESUBDIR = /boot
MKI_PACK_RESULTS = data

PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs

include /usr/share/mkimage/targets.mk

#all: build-propagator pack-image
all: build-propagator
