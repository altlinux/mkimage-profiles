ifeq (ve,$(IMAGE_CLASS))

# no "vzctl enter"
ve/bare: ve/.base +sysvinit; @:

# /dev/pty and friends start here
ve/base: ve/bare use/net-dns/level3
	@$(call add,BASE_PACKAGES,interactivesystem)

# a particular package list
ve/ldv: ve/bare use/control/server/ldv
	@$(call add,BASE_PACKAGES,xz bzip2 glibc hostinfo less)
	@$(call add,BASE_PACKAGES,vim-console netlist rsync time)
	@$(call add,BASE_PACKAGES,openssh-blacklist openssh-server)
	@$(call add,BASE_PACKAGES,shadow-edit shadow-groups)

ve/docker: ve/.apt use/repo
	@$(call add,BASE_PACKAGES,iproute2)

# build environment
ve/builder: ve/base use/dev/builder/base use/repo
	@$(call add,BASE_LISTS,openssh)

# this should be more or less convenient
ve/generic: ve/base use/repo
	@$(call add,BASE_PACKAGES,vim-console etckeeper apt-rsync)
	@$(call add,BASE_LISTS,openssh \
		$(call tags,base && (server || network || security || pkg)))

# example of service-specific template
ve/openvpn: ve/bare
	@$(call add,BASE_LISTS,$(call tags,server openvpn))

ve/pgsql: ve/generic
	@$(call add,BASE_PACKAGES,postgresql-server)

ve/samba-DC: ve/generic
	@$(call add,BASE_PACKAGES,task-samba-dc glibc-locales net-tools)

ve/sysvinit-etcnet: ve/base use/net/etcnet \
	use/control/sudo-su use/repo use/net-ssh
	@$(call add,BASE_PACKAGES,glibc-gconv-modules glibc-locales tzdata bash-completion iptables curl)

ve/systemd-bare: ve/.apt use/init/systemd \
	use/control/sudo-su use/repo
	@$(call add,BASE_PACKAGES,interactivesystem su)

ve/systemd-base: ve/systemd-bare
	@$(call add,BASE_PACKAGES,apt-scripts)
	@$(call add,BASE_PACKAGES,systemd-settings-disable-kill-user-processes)
	@$(call add,BASE_PACKAGES,glibc-gconv-modules glibc-locales tzdata bash-completion iptables curl)

ve/systemd-networkd: ve/systemd-base use/net-ssh use/net/networkd/resolved; @:
ve/systemd-etcnet: ve/systemd-base use/net-ssh use/net/etcnet; @:

ve/.lxc-bare: use/lxc-guest
	@$(call add,NET_ETH,eth0:dhcp)

ve/.lxc-base: ve/.lxc-bare
	@$(call add,BASE_PACKAGES,vim-console)

ve/lxc-sysvinit-etcnet: ve/.lxc-base ve/sysvinit-etcnet use/net-eth; @:
ve/lxc-systemd-etcnet: ve/.lxc-base ve/systemd-etcnet use/net-eth; @:
ve/lxc-systemd-networkd: ve/.lxc-base \
	ve/systemd-networkd use/net-eth/networkd; @:

ve/lxc-builder: ve/lxc-sysvinit-etcnet use/dev/builder/base use/repo
	@$(call add,BASE_LISTS,openssh)

endif
