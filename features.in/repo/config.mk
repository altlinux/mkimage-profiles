use/repo:
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,gnupg)

use/repo/main: sub/main use/repo; @:

use/repo/addon: use/repo/main
	@$(call set,MAIN_SUFFIX,addon)
