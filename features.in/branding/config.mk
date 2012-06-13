# NB: release part of branding goes to install2 feature
use/branding:
	@$(call add_feature)

# NB: not every distro might have all the branding of its own
use/branding/full: use/branding use/syslinux/ui/gfxboot
	@$(call add,THE_BRANDING,alterator bootsplash graphics)
	@$(call add,THE_BRANDING,indexhtml notes slideshow)

use/branding/complete: use/branding/full use/plymouth/full
	@$(call add,INSTALL2_BRANDING,notes slideshow)
