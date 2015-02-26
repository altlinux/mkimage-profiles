+sysvinit: use/init/sysv; @:
+systemd: use/init/systemd; @:

use/init:
	@$(call add_feature)
	@$(call add,THE_LISTS,$$(INIT_TYPE))

# THE_LISTS is too late when BASE_PACKAGES have pulled in
# the wrong syslogd-daemon provider already
use/init/sysv: use/init
	@$(call set,INIT_TYPE,sysvinit)
	@$(call add,BASE_PACKAGES,syslogd)
	@$(call add,BASE_PACKAGES_REGEXP,^systemd- ^systemd-services-)

### i-f should be dropped as soon as rootfs scripts are effective there
use/init/systemd: use/init
	@$(call set,INIT_TYPE,systemd)
	@$(call add,INSTALL2_PACKAGES,installer-feature-journald-tty)

use/init/systemd/debug: use/init/systemd use/services
	@$(call add,SERVICES_ENABLE,debug-shell)
