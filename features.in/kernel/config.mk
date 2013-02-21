# choose std kernel flavour for max RAM size support
ifeq (i586,$(ARCH))
BIGRAM := std-pae
else
BIGRAM := std-def
endif

use/kernel:
	@$(call add_feature)
	@$(call set,KFLAVOURS,std-def)

use/kernel/net:
	@$(call add,THE_KMODULES,e1000e igb r8168 rtl8168)
