### various mixins with their origin

### e2k.mk
mixin/e2k-base: use/tty/S0 use/net-eth/dhcp; @:

mixin/e2k-desktop: use/e2k/x11 use/l10n/default/ru_RU \
	use/browser/firefox/esr use/browser/firefox \
	use/fonts/otf/adobe use/fonts/otf/mozilla
	@$(call add,THE_PACKAGES,xinit xterm mc)
	@$(call add,THE_PACKAGES,fonts-bitmap-terminus)

mixin/e2k-livecd-install: use/e2k/x11
	@$(call add,THE_PACKAGES,livecd-install)
	@$(call add,THE_PACKAGES,fdisk hdparm rsync openssh vim-console)
	@$(call add,THE_PACKAGES,apt-repo)

mixin/e2k-mate: use/e2k/x11 use/x11/xorg use/fonts/install2 \
	use/deflogin/live use/deflogin/xgrp \
	use/x11/mate use/x11/lightdm/slick \
	use/fonts/otf/adobe use/fonts/otf/mozilla \
	use/fonts/ttf/google use/fonts/ttf/redhat
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,THE_BRANDING,mate-settings)
	@$(call add,THE_BRANDING,alterator)
	@$(call add,THE_BRANDING,graphics)
	@$(call add,THE_PACKAGES,setup-mate-terminal)
	@$(call add,THE_PACKAGES,setup-mate-nocomposite)
	@$(call add,THE_PACKAGES,alterator-standalone)
	@$(call add,THE_PACKAGES,terminfo-extra)
	@$(call add,THE_PACKAGES,ethtool net-tools ifplugd)
	@$(call add,THE_PACKAGES,zsh bash-completion)

mixin/vm-archdep:: use/auto-resize; @:

ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
mixin/vm-archdep:: +efi
endif

ifeq (,$(filter-out armh aarch64,$(ARCH)))
mixin/vm-archdep:: use/bootloader/uboot use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
mixin/vm-archdep:: use/tty/S0
	@$(call set,KFLAVOURS,un-malta)
endif

ifeq (,$(filter-out riscv64,$(ARCH)))
mixin/vm-archdep:: use/bootloader/uboot
	@$(call set,KFLAVOURS,un-def)
endif

mixin/vm-archdep-x11: mixin/vm-archdep use/vmguest/kvm/x11; @:

mixin/uboot-extlinux: use/bootloader/uboot
	@$(call set,EFI_BOOTLOADER,)

mixin/uboot-extlinux-efi: use/uboot +efi; @:
ifeq (aarch64,$(ARCH))
	@$(call set,VM_PARTTABLE,msdos)
	@$(call set,VM_BOOTTYPE,EFI)
endif

mixin/waydroid: ; @:
ifeq (,$(filter-out aarch64 x86_64,$(ARCH)))
	@$(call add,THE_PACKAGES,libgbinder1 waydroid)
	@$(call add,THE_KMODULES,anbox)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,waydroid-container.service)
	@$(call add,BASE_BOOTARGS,psi=1)
endif

### regular.mk
mixin/regular-x11: use/browser/firefox \
	use/branding use/ntp/chrony use/services/lvm2-disable
	@$(call add,THE_LISTS,$(call tags,(base || desktop) && regular && !extra))
	@$(call add,THE_PACKAGES,disable-usb-autosuspend)
	@$(call add,THE_PACKAGES,btrfs-progs)
	@$(call add,THE_PACKAGES,gpm)
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm powertop)
ifneq (sisyphus,$(BRANCH))
	@$(call set,FX_FLAVOUR,-esr)
endif

# common WM live/installer bits
mixin/regular-desktop: +alsa +nm-native \
	use/x11/xorg use/xdg-user-dirs use/l10n use/l10n/xkb/switch/alt_shift \
	use/fonts/otf/adobe use/fonts/otf/mozilla use/branding/notes
	@$(call set,LOCALES,en_US ru_RU pt_BR)
	@$(call add,THE_PACKAGES,pam-limits-desktop beesu polkit dvd+rw-tools)
	@$(call add,THE_PACKAGES,eepm)
	@$(call add,THE_PACKAGES,sudo)
	@$(call add,THE_BRANDING,alterator graphics indexhtml)
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,THE_BRANDING,notes)
endif
	@$(call add,THE_PACKAGES,$$(THE_IMAGEWRITER))
	@$(call set,THE_IMAGEWRITER,altmediawriter)
	@$(call add,THE_PACKAGES,upower udev-rules-rfkill-uaccess)
	@$(call add,THE_PACKAGES,hunspell-ru-lebedev hunspell-en_US)
	@$(call add,THE_PACKAGES,glmark2 glmark2-es2)
	@$(call add,DEFAULT_SERVICES_DISABLE,gssd idmapd krb5kdc rpcbind)
	@$(call add,DEFAULT_SERVICES_ENABLE,cups)
	@$(call add,DEFAULT_SERVICES_ENABLE,alteratord)
	@$(call add,CONTROL,fusermount:public)
	@$(call add,CONTROL,libnss-role:disabled)

mixin/desktop-extra:
	@$(call add,BASE_LISTS,$(call tags,(archive || base) && extra))

mixin/regular-wmaker: use/fonts/ttf/redhat use/x11/wmaker +nm-gtk
	@$(call add,LIVE_PACKAGES,installer-feature-no-xconsole-stage3)
	@$(call add,MAIN_PACKAGES,wmgtemp wmhdaps wmxkbru xxkb)

mixin/regular-icewm: use/fonts/ttf/redhat +icewm +nm-gtk
	@$(call add,THE_LISTS,$(call tags,regular icewm))
	@$(call add,THE_PACKAGES,icewm-startup-networkmanager)
	@$(call add,THE_PACKAGES,mnt)

mixin/regular-gnustep: use/x11/gnustep
	@$(call add,THE_BRANDING,graphics)

mixin/regular-cinnamon: use/x11/cinnamon use/x11/lightdm/slick +nm-gtk \
	use/fonts/ttf/google use/im use/domain-client
	@$(call add,THE_PACKAGES,xdg-user-dirs-gtk)
	@$(call add,THE_PACKAGES,gnome-disk-utility gnome-system-monitor)

mixin/regular-deepin: use/x11/deepin use/browser/chromium +nm; @:

mixin/regular-gnome: use/x11/gnome use/fonts/ttf/redhat +nm-gtk4 \
	use/domain-client
	@$(call add,THE_PACKAGES,power-profiles-daemon)
	@$(call add,BASE_PACKAGES,gnome-software)
	@$(call add,BASE_PACKAGES,gnome-tour)
ifeq (,$(filter-out sisyphus p11,$(BRANCH)))
	@$(call add,THE_PACKAGES,gnome-extension-manager)
	@$(call add,PINNED_PACKAGES,gnome-console:Required)
	@$(call add,THE_PACKAGES,gnome-console)
	@$(call add,THE_PACKAGES,papers)
else
	@$(call add,PINNED_PACKAGES,gnome-terminal:Required)
	@$(call add,THE_PACKAGES,gnome-terminal)
	@$(call add,THE_PACKAGES,evince)
endif
	@$(call add,THE_PACKAGES,chrome-gnome-shell)
	@$(call add,THE_PACKAGES,qt5-wayland qt6-wayland)
	@$(call add,THE_PACKAGES,cups-pk-helper cups)
	@$(call add,THE_PACKAGES,fonts-ttf-lxgw-wenkai)
	@$(call add,THE_PACKAGES,xdg-user-dirs-gtk)

mixin/regular-kde: use/x11/kde \
	use/x11/kde-display-manager-lightdm \
	use/fonts/ttf/google use/fonts/ttf/redhat use/fonts/zerg \
	use/domain-client
ifeq (,$(filter-out sisyphus p11,$(BRANCH)))
	@$(call add,THE_PACKAGES,xdg-desktop-portal-kde)
	@$(call add,BASE_PACKAGES,plasma-discover)
	@$(call add,THE_PACKAGES,kf5-kirigami)
	@$(call add,THE_PACKAGES,kf5-kio)
	@$(call set,DEFAULT_SESSION,plasma)
else
	@$(call add,THE_PACKAGES,plasma5-xdg-desktop-portal-kde)
	@$(call add,BASE_PACKAGES,plasma5-discover)
endif
	@$(call add,THE_PACKAGES,xdg-desktop-portal-gtk)
	@$(call add,THE_PACKAGES,qt5-wayland)
	@$(call add,THE_PACKAGES,qt6-wayland)
	@$(call add,THE_PACKAGES,accountsservice)
	@$(call add,THE_PACKAGES,gtk-theme-breeze)

mixin/xfce-base: use/x11/xfce +nm-gtk \
	use/fonts/ttf/redhat use/fonts/ttf/google/extra
	@$(call add,THE_PACKAGES,xfce4-regular)
	@$(call add,THE_PACKAGES,xreader)
	@$(call add,THE_PACKAGES,xdg-user-dirs-gtk)
	@$(call add,THE_PACKAGES,xkill)

mixin/regular-xfce: mixin/xfce-base use/domain-client +pipewire
	@$(call add,THE_PACKAGES,pavucontrol xscreensaver-frontend)
	@$(call add,THE_PACKAGES,xfce4-pulseaudio-plugin xfce-polkit)

mixin/regular-lxde: use/x11/lxde use/im +nm-gtk
	@$(call add,THE_PACKAGES,qasmixer qpdfview)

mixin/regular-lxqt: use/x11/lxqt +nm-gtk use/domain-client; @:

mixin/mate-base: use/x11/mate use/fonts/ttf/google +nm-gtk
	@$(call add,THE_LISTS,$(call tags,mobile mate))

mixin/regular-mate: mixin/mate-base use/domain-client; @:
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,THE_LISTS,$(call tags,base smartcard))
endif

mixin/office: use/fonts/ttf/google use/fonts/ttf/xo
	@$(call add,THE_LISTS,$(call tags,desktop && (cups || office)))
	@$(call add,THE_PACKAGES,apt-indicator)

# NB: never ever use/syslinux/ui/gfxboot here as gfxboot mangles
#     kernel cmdline resulting in method:disk instead of method:cdrom
#     which will change propagator's behaviour to probe additional
#     filesystems (ro but no loop) thus potentially writing to
#     an unrecovered filesystem's journal
mixin/regular-rescue: use/rescue use/isohybrid use/luks use/branding \
	use/syslinux/ui/menu use/syslinux/timeout/600 \
	use/rescue/.base use/syslinux/sdab.cfg use/grub/sdab_bios.cfg \
	use/firmware/qlogic test/rescue/no-x11 +sysvinit; @:

mixin/regular-builder: use/dev/builder/base use/net/dhcp use/ntp/chrony
	@$(call add,THE_PACKAGES,bash-completion elinks gpm lftp openssh)
	@$(call add,THE_PACKAGES,rpm-utils screen tmux wget zsh)
	@$(call add,THE_PACKAGES,apt-repo)

### vm.mk
mixin/cloud-init:
	@$(call add,BASE_PACKAGES,cloud-init)
	@$(call add,DEFAULT_SERVICES_ENABLE,cloud-config cloud-final)
	@$(call add,DEFAULT_SERVICES_ENABLE,cloud-init cloud-init-local)
	@$(call set,GLOBAL_NET_ETH,)

mixin/opennebula-context:
	@$(call add,BASE_PACKAGES,opennebula-context)
	@$(call add,DEFAULT_SERVICES_ENABLE,one-context-local one-context)

mixin/icewm: use/x11/lightdm/gtk +icewm; @:
