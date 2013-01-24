# choose std kernel flavour for max RAM size support
ifeq (i586,$(ARCH))
BIGRAM := std-pae
else
BIGRAM := std-def
endif

use/kernel:
	@$(call add_feature)
	@$(call set,KFLAVOURS,std-def)
