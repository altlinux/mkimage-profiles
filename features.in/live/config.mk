+live: use/live/desktop; @:

# service defaults
_ON = alteratord cpufreq-simple \
      livecd-evms livecd-fstab livecd-hostname \
      livecd-setauth livecd-setlocale livecd-timezone livecd-net-eth livecd-install-wmaker \
      random rpcbind plymouth avahi-daemon \

_OFF = anacron blk-availability bridge clamd dhcpd dmeventd dnsmasq \
       mdadm netfs o2cb ocfs2 openvpn postfix rawdevices slapd smartd sshd \
       sysstat update_wms xinetd

# copy stage2 as live
# NB: starts to preconfigure but doesn't use/cleanup yet
use/live: use/stage2 sub/rootfs@live sub/stage2@live \
	use/services/lvm2-disable use/grub/live.cfg
	@$(call add_feature)
	@$(call add,CLEANUP_BASE_PACKAGES,'installer*')
	@$(call add,DEFAULT_SERVICES_ENABLE,$(_ON))
	@$(call add,DEFAULT_SERVICES_DISABLE,$(_OFF))
	@$(call add,CONTROL,rpcbind:local)
	@$(call xport,LIVE_CLEANUP_KDRIVERS)

use/live/.base: use/live use/syslinux/ui/menu
	@$(call add,LIVE_LISTS,$(call tags,base live))

use/live/no-cleanup: \
	use/cleanup/live-no-cleanupdb \
	use/cleanup/live-no-cleanup-docs; @:

use/live/base: use/live/.base use/net use/deflogin/live
	@$(call add,LIVE_LISTS,$(call tags,base network))

use/live/rw: use/live use/syslinux/live_rw.cfg use/grub/live_rw.cfg; @:

# graphical target (not enforcing xorg drivers or blobs)
use/live/x11: use/live/base use/deflogin/desktop use/x11-autologin use/sound \
	use/fonts/otf/adobe use/fonts/otf/mozilla +efi
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_LISTS,$(call tags,base l10n))
	@$(call add,LIVE_PACKAGES,pciutils)

# this target specifically pulls free xorg drivers in (and a few more bits);
# a browser is requested too, the recommended one can be overridden downstream
use/live/desktop: use/live/x11 use/x11/xorg use/x11/wacom \
	use/l10n use/browser/firefox/live use/xdg-user-dirs/deep \
	use/syslinux/localboot.cfg +vmguest; @:

# preconfigure apt for both live and installed-from-live systems
use/live/repo: use/live
	@$(call try,LIVE_REPO,http/yandex)
	@$(call xport,LIVE_REPO)

# preconfigure apt in runtime (less reliable)
use/live/repo/online:
	@$(call add,LIVE_PACKAGES,livecd-online-repo)

# alterator-based permanent installation
use/live/install: use/metadata use/xdg-user-dirs use/syslinux/localboot.cfg \
	use/bootloader/live use/bootloader/grub
	@$(call add,LIVE_PACKAGES,livecd-install)
	@$(call add,LIVE_PACKAGES,livecd-installer-features)

# text-based installation script
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/live/textinstall: use/syslinux/lateboot.cfg
	@$(call add,LIVE_PACKAGES,live-install)
else
use/live/textinstall: ; @:
endif

# a very simplistic one
use/live/.x11: use/live use/x11 use/x11-autologin
	@$(call add,LIVE_PACKAGES,xinit)

# NB: some implementation has to be added if it's not a display manager
use/live/autologin: use/live/.x11
	@$(call add,LIVE_PACKAGES,autologin)

use/live/nodm: use/live/.x11
	@$(call add,LIVE_PACKAGES,nodm)

# see also http://www.altlinux.org/Netbook-live/hooks
use/live/hooks: use/live
	@$(call add,LIVE_PACKAGES,livecd-run-hooks)

# a crude hack to make sure Russian is the default in a particular image
use/live/ru: use/live use/l10n/default/ru_RU; @:

use/live/sound: use/live
	@$(call add,LIVE_LISTS,sound/base)

ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
# prepare bootloader for software suspend (see also install2)
use/live/suspend: use/live
	@$(call add,LIVE_PACKAGES,installer-feature-desktop-suspend-stage2)
else
use/live/suspend: use/live; @:
endif

# deny network/local drive access for security reasons
use/live/privacy: use/services use/memclean use/deflogin \
	use/stage2/ata use/stage2/drm use/stage2/hid \
	use/stage2/mmc use/stage2/net-nfs use/stage2/usb
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-nodisks)
	@$(call add,LIVE_PACKAGES,livecd-nodisks)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/net/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/net/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/ata/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/scsi/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/block/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/cdrom/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/firewire/)
	@$(call add,LIVE_CLEANUP_KDRIVERS,kernel/drivers/bluetooth/)
	@$(call add,USERS,altlinux:::)
