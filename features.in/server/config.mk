use/server:
	@$(call add_feature)

use/server/mini: use/server use/net-ssh
	@$(call add,THE_KMODULES,e1000e igb)
	@$(call add,STAGE1_KMODULES,e1000e igb)
	@$(call add,THE_LISTS,\
		$(call tags,base && (server || network || security || pkg)))
	@$(call add,THE_LISTS,$(call tags,extra && (server || network)))
	@$(call add,MAIN_LISTS,osec)
