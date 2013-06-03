+sysvinit: use/init/sysv; @:
+systemd: use/init/systemd; @:

use/init:
	@$(call add_feature)
	@$(call add,THE_LISTS,$$(INIT_TYPE))

use/init/sysv: use/init
	@$(call set,INIT_TYPE,sysvinit)

### i-f should be dropped as soon as rootfs scripts are effective there
use/init/systemd: use/init
	@$(call set,INIT_TYPE,systemd)
	@$(call add,BASE_PACKAGES,installer-feature-systemd-stage3)
