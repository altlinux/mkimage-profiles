# ../scripts.d/01-genbasedir needs that
CHROOT_PACKAGES += apt-utils

# Proxy for main repo
INFO_ARCH := $(ARCH) noarch
INFO_NAME := $(META_APP_ID)
INFO_VERSION := $(DISTRO_VERSION)
INFO_ORIGIN := $(META_PUBLISHER)
INFO_LABEL := $(BRANCH)
INFO_SUITE := $(INFO_LABEL)
