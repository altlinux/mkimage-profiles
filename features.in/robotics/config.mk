+robotics: use/robotics/reprap use/robotics/umki; @:

use/robotics/reprap: use/x11/3d
	@$(call add_feature)
	@$(call add,THE_LISTS,robotics/reprap)

use/robotics/umki:
	@$(call add_feature)
	@$(call add,THE_LISTS,robotics/umki)
