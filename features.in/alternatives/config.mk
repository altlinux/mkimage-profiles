use/alternatives:
	@$(call add_feature)
	@$(call xport,ALTERNATIVES)

use/alternatives/xvt/%: use/alternatives
	@$(call add,ALTERNATIVES,/usr/bin/xvt:/usr/bin/$*)
