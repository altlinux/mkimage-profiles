use/slinux: use/x11
	@$(call add_feature)
	@$(call set,BRANDING,simply-linux)
	@$(call set,GRUBTHEME,slinux)
	@$(call add,THE_BRANDING,menu xfce-settings system-settings)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)

use/slinux/services-enabled:
	@$(call add_feature)
	@$(call add,SYSTEMD_SERVICES_ENABLE,NetworkManager.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,NetworkManager-wait-online.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,ModemManager.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,alteratord.socket)
	@$(call add,SYSTEMD_SERVICES_ENABLE,anacron.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,avahi-daemon.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,bluetooth.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,cpufreq-simple.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,crond.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,cups.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,dnsmasq.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,lightdm.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,lvm2-monitor.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,network.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,nmb.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,smb.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,x11presetdrv.service)

use/slinux/services-disabled:
	@$(call add_feature)
	@$(call add,SYSTEMD_SERVICES_DISABLE,acpid.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,clamd.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,consolesaver.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,cups.socket)
	@$(call add,SYSTEMD_SERVICES_DISABLE,ethtool.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,haspd.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,iptables.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,krb5kdc.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,lm_sensors.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,openvpn.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,sshd.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,syslogd.service)

use/slinux/services: use/slinux/services-enabled use/slinux/services-disabled

ifeq (,$(filter-out riscv64,$(ARCH)))
use/slinux/vm-base:: use/oem/vnc
	@$(call set,KFLAVOURS,un-def)
endif

use/slinux/vm-base:: vm/systemd \
	use/oem/distro use/slinux/mixin-base
	@$(call add,THE_LISTS,slinux/games-base)
	@$(call add,THE_LISTS,slinux/graphics-base)
	@$(call add,THE_LISTS,slinux/multimedia-base)
	@$(call add,THE_LISTS,slinux/net-base)
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,THE_PACKAGES,installer-feature-online-repo)
	@$(call add,THE_PACKAGES,installer-feature-samba-usershares-stage2)
	@$(call add,THE_PACKAGES,installer-feature-sudo-enable-by-default-stage3)

use/slinux/mixin-base: use/slinux use/x11/xorg use/x11/lightdm/gtk +pulse \
	+nm use/x11/gtk/nm +systemd +systemd-optimal +wireless \
	use/l10n/default/ru_RU \
	use/ntp/chrony \
	use/office/LibreOffice/full \
	use/docs/manual use/docs/indexhtml \
	use/xdg-user-dirs/deep use/slinux/services
	@$(call set,DOCS,simply-linux)
	@$(call add,THE_LISTS,gnome-p2p)
	@$(call add,LIVE_LISTS,slinux/games-base)
	@$(call add,LIVE_LISTS,slinux/graphics-base)
	@$(call add,LIVE_LISTS,slinux/multimedia-base)
	@$(call add,LIVE_LISTS,slinux/net-base)
	@$(call add,THE_LISTS,slinux/misc-base)
	@$(call add,THE_LISTS,slinux/xfce-base)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_KMODULES,staging)
ifeq (,$(filter-out armh aarch64 mipsel e2k%,$(ARCH)))
	@$(call add,THE_LISTS,slinux/browser-firefox)
	@$(call add,THE_LISTS,slinux/multimedia-player-celluloid)
else
	@$(call add,THE_LISTS,slinux/browser-chromium)
	@$(call add,THE_LISTS,slinux/multimedia-player-vlc)
endif
ifeq (,$(filter-out armh aarch64 i586 x86_64,$(ARCH)))
	@$(call set,KFLAVOURS,un-def)
endif

use/slinux/base: use/isohybrid use/luks \
	+plymouth use/memtest +vmguest \
	+efi \
	use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb \
	use/live/x11 use/live/rw use/install2/fonts \
	use/efi/memtest86 use/efi/shell \
	use/bootloader/grub \
	use/branding/complete \
	mixin/desktop-installer \
	use/vmguest/kvm/x11 use/stage2/kms \
	use/slinux/mixin-base \
	use/cleanup/live-no-cleanupdb
	@$(call add,LIVE_LISTS,slinux/live)
	@$(call add,BASE_PACKAGES,installer-distro-simply-linux-stage3)
	@$(call add,STAGE2_PACKAGES,xorg-conf-libinput-touchpad)

use/slinux/full: use/slinux/base
	@$(call add,MAIN_LISTS,slinux/not-install-full)
	@$(call add,THE_LISTS,slinux/misc-full)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,THE_KMODULES,virtualbox)
	@$(call add,THE_KMODULES,nvidia)
#	@$(call add,THE_KMODULES,fglrx)
	@$(call add,MAIN_KMODULES,bbswitch)
endif

use/slinux/arm: use/slinux use/x11/lightdm/gtk
	@$(call add,THE_LISTS,slinux-arm)
