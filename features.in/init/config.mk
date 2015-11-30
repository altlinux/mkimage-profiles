+sysvinit: use/init/sysv; @:
+systemd: use/init/systemd; @:

use/init:
	@$(call add_feature)
	@$(call add,THE_LISTS,$$(INIT_TYPE))
	@$(call add,RESCUE_LISTS,$$(INIT_TYPE))

# THE_LISTS is too late when BASE_PACKAGES have pulled in
# the wrong syslogd-daemon provider already
use/init/sysv: use/init
	@$(call set,INIT_TYPE,sysvinit)
	@$(call add,BASE_PACKAGES,syslogd)

use/init/sysv/polkit: use/init/sysv
	@$(call add,THE_PACKAGES,polkit-sysvinit)

### i-f should be dropped as soon as rootfs scripts are effective there
use/init/systemd: use/init
	@$(call set,INIT_TYPE,systemd)
	@$(call add,INSTALL2_PACKAGES,installer-feature-journald-tty)

# http://www.freedesktop.org/wiki/Software/systemd/Debugging
use/init/systemd/debug: use/init/systemd use/services
	@$(call add,THE_PACKAGES,systemd-shutdown-debug-script)
	@$(call add,SERVICES_ENABLE,debug-shell)
	@$(call add,STAGE2_BOOTARGS,systemd.log_level=debug)
	@$(call add,STAGE2_BOOTARGS,systemd.log_target=kmsg)
	@$(call add,STAGE2_BOOTARGS,log_buf_len=1M enforcing=0)
