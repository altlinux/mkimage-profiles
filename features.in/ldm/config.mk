+ldm: use/ldm/session; @:

# common
use/ldm: sub/rootfs use/services
	@$(call add_feature)
	@$(call add,COMMON_PACKAGES,ldm-tools)

# configure X11 session
use/ldm/session: use/ldm
	@$(call add,COMMON_PACKAGES,ldm-session-init)
	@$(call add,DEFAULT_SERVICES_ENABLE,ldm)

# configure lightdm session
use/ldm/session/lightdm: use/ldm/session
	@$(call add,COMMON_PACKAGES,ldm-session-init-lightdm)

# configure sddm session
use/ldm/session/sddm: use/ldm/session
	@$(call add,COMMON_PACKAGES,ldm-session-init-sddm)

# configure gdm session
use/ldm/session/gdm: use/ldm/session
	@$(call add,COMMON_PACKAGES,ldm-session-init-gdm)
