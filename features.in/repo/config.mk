use/repo:
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,gnupg)

use/repo/main: sub/main use/repo; @:
