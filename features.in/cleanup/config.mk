use/cleanup:
	@$(call add_feature)
	@$(call xport,CLEANUP_PACKAGES)

use/cleanup/libs:
	@$(call add,BASE_PACKAGES,apt-scripts)
	@$(call add,INSTALL2_PACKAGES,installer-feature-cleanup-libs-stage3)

use/cleanup/installer: use/cleanup
	@$(call add,CLEANUP_PACKAGES,'installer-*')

use/cleanup/x11: use/cleanup use/cleanup/libs
	@$(call add,CLEANUP_PACKAGES,libICE libSM libxcb 'libX*')

# as some alterator modules are installed into stage3 (the destination
# root filesystem) to perform actions like bootloader setup, we might
# have to remove them (contrary to the usual build-up)...
use/cleanup/alterator: use/cleanup
	@$(call add,CLEANUP_PACKAGES,'alterator*' rpm-macros-alterator)
	@$(call add,CLEANUP_PACKAGES,'guile*' libvhttpd)

# for lightweight server distros
use/cleanup/x11-alterator: use/cleanup/x11 use/cleanup/alterator
	@$(call add,CLEANUP_PACKAGES,libmng qt4-common)
