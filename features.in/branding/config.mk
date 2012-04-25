use/branding:
	@$(call add_feature)
	@### see install2
	@#$(call add,BASE_PACKAGES,branding-$$(BRANDING)-release)

# NB: not every distro might have all the branding of its own
use/branding/full: use/branding use/syslinux/ui/gfxboot
	@$(call add,THE_BRANDING,alterator bootsplash graphics)
	@$(call add,THE_BRANDING,indexhtml notes slideshow)

use/branding/complete: use/branding/full
	@$(call add,INSTALL2_BRANDING,notes slideshow)
