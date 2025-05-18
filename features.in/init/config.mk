+sysvinit: use/init/sysv; @:
+systemd: use/init/systemd/full; @:
+systemd-optimal: use/init/systemd/settings/optimal; @:

# NB: the list name MUST be identical to init package name
use/init: use/pkgpriorities
	@$(call add_feature)
	@$(call add,THE_LISTS,$$(INIT_TYPE))
	@$(call add,PINNED_PACKAGES,$$(INIT_TYPE))
	@$(call add,SYSTEM_PACKAGES,kbd kbd-data)
ifeq (,$(filter-out p10 c10%,$(BRANCH)))
	@$(call add,THE_PACKAGES,startup) # contains configs needed all
ifeq (distro,$(IMAGE_CLASS))
	@$(call try,INSTALL2_INIT,init=/usr/sbin/install2-init)
endif
endif

# THE_LISTS is too late when BASE_PACKAGES have pulled in
# the wrong syslogd-daemon provider already
use/init/sysv: use/init
	@$(call set,INIT_TYPE,sysvinit)
	@$(call add,INSTALL2_PACKAGES,sysvinit)
	@$(call add,SYSTEM_PACKAGES,console-scripts)
	@$(call add,THE_PACKAGES,rsyslog-classic startup mingetty)
	@$(call add,THE_PACKAGES,udevd-final)
	@$(call add,DEFAULT_SERVICES_ENABLE,udevd-final)
	@$(call add,PINNED_PACKAGES,rsyslog-classic)
	@$(call add,PINNED_PACKAGES,systemd-utils-standalone:Essential)
ifeq (,$(filter-out x86_64 aarch64,$(ARCH)))
	@$(call add,THE_PACKAGES,mount-efivars)
endif
ifneq (,$(filter-out p10 c10%,$(BRANCH)))
ifeq (distro,$(IMAGE_CLASS))
	@$(call try,INSTALL2_INIT,init=/usr/libexec/install2/install2-init)
endif
endif

use/init/sysv/polkit: use/init/sysv
	@$(call add,THE_PACKAGES,polkit-sysvinit)

### i-f should be dropped as soon as rootfs scripts are effective there
use/init/systemd: use/init
	@$(call set,INIT_TYPE,systemd)
ifeq (distro,$(IMAGE_CLASS))
ifneq (,$(filter-out p10 c10%,$(BRANCH)))
	@$(call add,INSTALL2_PACKAGES,systemd-sysvinit)
	@$(call try,INSTALL2_INIT,systemd.unit=install2.target)
endif
endif

use/init/systemd/full: use/init/systemd
	@$(call add,THE_PACKAGES,chkconfig)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,THE_PACKAGES,vconsole-setup-kludge)
endif

# http://www.freedesktop.org/wiki/Software/systemd/Debugging
use/init/systemd/debug: use/init/systemd use/services
	@$(call add,THE_PACKAGES,systemd-shutdown-debug-script)
	@$(call add,SERVICES_ENABLE,debug-shell)
	@$(call add,STAGE2_BOOTARGS,systemd.log_level=debug)
	@$(call add,STAGE2_BOOTARGS,systemd.log_target=kmsg)
	@$(call add,STAGE2_BOOTARGS,log_buf_len=1M enforcing=0)

# set multi-user target by default
use/init/systemd/multiuser: use/init/systemd
	@$(call add,STAGE2_BOOTARGS,systemd.unit=multi-user.target)

use/init/systemd/settings/disable-user-systemd-for-selinux \
	use/init/systemd/settings/enable-log-to-tty12 \
	use/init/systemd/settings/enable-showstatus: \
	use/init/systemd/settings/%: use/init/systemd
	@$(call add,THE_PACKAGES,systemd-settings-$*)

use/init/systemd/settings/optimal: use/init/systemd \
	use/init/systemd/settings/enable-log-to-tty12 \
	use/init/systemd/settings/enable-showstatus; @:
