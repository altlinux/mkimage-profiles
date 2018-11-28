ifeq (vm,$(IMAGE_CLASS))

vm/.e2k-bare: vm/.bare use/e2k
	@$(call add,BASE_PACKAGES,apt)

vm/e2k-live: vm/.e2k-bare use/deflogin/live use/net-ssh use/control/sudo-su
	@$(call add,THE_LISTS,$(call tags,ve tools))

vm/.e2k-rescue: vm/e2k-live \
	mixin/e2k-base use/net/etcnet use/services/lvm2-disable
	@$(call add,THE_PACKAGES,agetty gpm fdisk parted smartmontools pv sshfs)
	@$(call add,THE_PACKAGES,make-initrd dhcpcd hdparm nfs-clients)
	@$(call add,THE_LISTS,$(call tags,server && (network || extra)))
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm mdadm smartd)

vm/alt-rescue: vm/.e2k-rescue +sysvinit
	@$(call add,KFLAVOURS,elbrus-def)

vm/e2k-xfce: vm/.e2k-rescue mixin/e2k-desktop use/x11/xfce
	@$(call add,THE_PACKAGES,pnmixer)

vm/e2k-mate: vm/.e2k-rescue use/deflogin/live use/x11/mate use/x11/lightdm/gtk \
	mixin/e2k-base mixin/e2k-desktop mixin/e2k-livecd-install
	@$(call add,THE_PACKAGES,LibreOffice-integrated LibreOffice-gnome)
	@$(call add,THE_PACKAGES,LibreOffice-langpack-ru)

vm/e2k-lxqt: vm/.e2k-rescue mixin/e2k-desktop
	@$(call add,THE_LISTS,$(call tags,desktop && lxqt && !extra))

vm/e2k-builder: vm/.e2k-rescue use/dev/builder/base
	@$(call add,KFLAVOURS,elbrus-8c elbrus-4c)

vm/e2k-samba-DC: vm/.e2k-rescue
	@$(call add,BASE_PACKAGES,task-samba-dc glibc-locales net-tools)

endif

ifeq (ve,$(IMAGE_CLASS))
ve/.e2k-bare: ve/.base use/e2k +sysvinit
	@$(call add,BASE_PACKAGES,apt)

ve/e2k-installer: ve/.e2k-bare use/repo/main
	@$(call add,MAIN_PACKAGES,hello)

ve/e2k-git: ve/.e2k-bare use/e2k use/net-ssh use/net-dns/yandex
	@$(call add,BASE_PACKAGES,git-server nginx)
	@$(call add,DEFAULT_SERVICES_ENABLE,xinetd git nginx)
endif

ifeq (distro,$(IMAGE_CLASS))
distro/.e2k-rescue: distro/.base mixin/e2k-base use/rescue/.base +net-eth
	@$(call set,META_VOL_ID,ALT Rescue for Elbrus)

distro/e2k-101-rescue: distro/.e2k-rescue
	@$(call add,KFLAVOURS,elbrus-1cp)

# NB: this one is NOT suited for a particular processor yet!
# (that's to be done downstream)
distro/.e2k-installer-base: distro/.base mixin/e2k-base \
	use/install2 use/install2/packages use/e2k/install2 \
	use/volumes/regular use/net-ssh +net-eth
	@$(call set,INSTALLER,altlinux-generic)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_VOL_ID,ALT for Elbrus)
	@$(call set,META_APP_ID,ALT/$(ARCH))
	@$(call add,INSTALL2_PACKAGES,agetty)
	@$(call add,INSTALL2_PACKAGES,ifplugd) ### for net-eth link status
	@$(call add,INSTALL2_BRANDING,alterator)
	@$(call add,THE_PACKAGES,agetty gpm fdisk parted smartmontools pv sshfs)
	@$(call add,THE_PACKAGES,make-initrd dhcpcd hdparm nfs-clients vim-console)
	@$(call add,THE_PACKAGES,python-module-serial)
	@$(call add,THE_LISTS,$(call tags,server && (network || extra)))
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm mdadm smartd)
	@$(call add,THE_BRANDING,alterator)
	@$(call set,BRANDING,alt-workstation)	### conflicts w/alt-sisyphus

distro/.e2k-installer-sysv: distro/.e2k-installer-base +sysvinit; @:
distro/.e2k-installer: distro/.e2k-installer-base +systemd; @:

distro/e2k-801-builder: distro/.e2k-installer-sysv \
	use/e2k/install2/801 use/dev/groups/builder; @:

distro/alt-jeos-401: distro/.e2k-installer-sysv use/e2k/install2/401
	@$(call set,META_VOL_ID,ALT JeOS 401)

distro/alt-jeos-801: distro/.e2k-installer-sysv use/e2k/install2/801
	@$(call set,META_VOL_ID,ALT JeOS 801)

distro/alt-jeos-101: distro/.e2k-installer-sysv use/e2k/install2/101
	@$(call set,META_VOL_ID,ALT JeOS 101)

distro/e2k-101-mate: distro/.e2k-installer use/e2k/101 \
	mixin/e2k-desktop mixin/e2k-mate
	@$(call add,THE_PACKAGES,LibreOffice-integrated LibreOffice-gnome)
	@$(call add,THE_PACKAGES,LibreOffice-langpack-ru)

distro/e2k-4xx-installer: distro/.e2k-installer-sysv use/e2k/install2/4xx
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm make-initrd-lvm)

distro/.e2k-installer-mate: distro/.e2k-installer \
	mixin/e2k-desktop mixin/e2k-mate; @:

endif
