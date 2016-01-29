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

# "basically everything else"; this *will* change with branches and distros
use/cleanup/jeos: use/cleanup/x11-alterator
	@$(call add,CLEANUP_PACKAGES,liblcms libjpeg 'libpng*' 'libtiff*')
	@$(call add,CLEANUP_PACKAGES,avahi-autoipd iw wpa_supplicant)
	@$(call add,CLEANUP_PACKAGES,openssl libpcsclite)
	@# a *lot* of stray things get pulled in by alterator modules
	@$(call add,CLEANUP_PACKAGES,libfreetype fontconfig)
	@$(call add,CLEANUP_PACKAGES,liblcms libjpeg 'libpng*' 'libtiff*')
	@$(call add,CLEANUP_PACKAGES,openssl libpcsclite)

# mostly non-interactive system
use/cleanup/jeos/full: use/cleanup/jeos
	@$(call add,CLEANUP_PACKAGES,interactivesystem 'groff*' man stmpclean)
	@$(call add,CLEANUP_PACKAGES,glibc-gconv-modules gettext)
	@$(call add,CLEANUP_PACKAGES,console-scripts console-vt-tools 'kbd*')
	@$(call add,CLEANUP_PACKAGES,libsystemd-journal libsystemd-login)
	@$(call add,CLEANUP_PACKAGES,dbus libdbus)
