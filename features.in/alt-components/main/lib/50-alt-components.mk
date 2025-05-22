CHROOT_PACKAGES += alterator-entry $(EDITION_PACKAGES)

# preparation targets of sub.in/main/Makefile
MAIN_WHATEVER += alt-components-main

alt-components-main:
	cp .work/chroot/tmp/.alt-components ../pkg/lists/.alt-components
