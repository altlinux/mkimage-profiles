# virtual machines
ifeq (vm,$(IMAGE_CLASS))

# NB: interactivesystem pulls in network-config-subsystem anyways
vm/bare: vm/.base-lilo +sysvinit
	@$(call add,BASE_PACKAGES,apt)

vm/systemd: vm/.base-grub +systemd
	@$(call add,BASE_PACKAGES,glibc-gconv-modules glibc-locales tzdata)
	@$(call add,BASE_PACKAGES,apt)

# handle ROOTPW (through deflogin)
vm/net: vm/bare use/net-eth/dhcp use/net-ssh \
	use/repo use/control/sudo-su use/deflogin
	@$(call add,BASE_PACKAGES,su)

vm/systemd-net: vm/systemd use/net-eth/networkd-dhcp use/net-ssh \
	use/repo use/control/sudo-su use/deflogin
	@$(call add,BASE_PACKAGES,su)

# vm/net or vm/systemd-net
vm/cloud-systemd: vm/systemd-net mixin/cloud-init use/vmguest/kvm use/tty/S0
	@$(call add,THE_KMODULES,drm)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)

vm/cloud-sysv: vm/net mixin/cloud-init use/vmguest/kvm use/power/acpi/button; @:

# vm with OpenNebula contextualization package (with empty network config)
vm/opennebula-systemd: vm/systemd use/net/networkd use/net-ssh \
	use/vmguest/kvm mixin/opennebula-context \
	use/repo use/control/sudo-su use/deflogin
	@$(call add,BASE_PACKAGES,su)

# NB: use/x11 employs some installer-feature packages
vm/.desktop-bare: vm/net use/x11/xorg use/cleanup/installer use/repo; @:

vm/.desktop-base: vm/.desktop-bare \
	use/deflogin/altlinuxroot use/x11-autologin; @:

vm/icewm: vm/.desktop-base mixin/icewm; @:

vm/icewm-setup: vm/.desktop-bare mixin/icewm use/oem use/x11-autostart
	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_BRANDING,graphics)
	@$(call add,THE_LISTS,$(call tags,base l10n))

# some arbitrary gigabyte
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
vm/vagrant-base: vm/net use/vagrant
	@$(call set,VM_SIZE,10737418240)
endif

endif
