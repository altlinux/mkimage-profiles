# choose std kernel flavour for max RAM size support
ifeq (i586,$(ARCH))
BIGRAM := std-pae
else
BIGRAM := std-def
endif

use/kernel:
	@$(call add_feature)
	@$(call try,KFLAVOURS,std-def)

# r8168 is a kludge, never install it by default
use/kernel/net:
	@$(call add,THE_KMODULES,e1000e igb)
	@$(call add,MAIN_KMODULES,r8168 rtl8168)

use/kernel/wireless: use/firmware/wireless
	@$(call add,THE_KMODULES,bcmwl ndiswrapper)

use/kernel/laptop: use/firmware/laptop
	@$(call add,THE_KMODULES,omnibook tp_smapi)

use/kernel/desktop:
	@$(call add,THE_KMODULES,lirc v4l)

use/kernel/server:
	@$(call add,THE_KMODULES,ipset kvm)
