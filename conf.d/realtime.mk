mixin/cnc-rt: use/l10n +nm-gtk +systemd +x11 \
	mixin/regular-desktop mixin/regular-lxqt use/x11/lightdm/gtk \
	use/cleanup
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
#	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,THE_LISTS,engineering/misc)
	@$(call add,THE_LISTS,kernel-headers)
	@$(call add,THE_PACKAGES,linuxcnc mesaflash)
	@$(call add,THE_PACKAGES,gcc-c++ liblinuxcnc-devel)
	@$(call add,THE_PACKAGES,alterator-x11)
	@$(call add,THE_PACKAGES,ethtool)
	@$(call add,THE_PACKAGES,python3-module-pip)
	@$(call add,THE_PACKAGES,openFPGALoader)
	@$(call add,THE_PACKAGES,xorg-conf-noblank)
	@$(call add,CLEANUP_PACKAGES,xscreensaver-modules)
	@$(call add,THE_PACKAGES,python3-module-pygobject3) # ALT bug 52950
ifneq (,$(filter-out p10,$(BRANCH)))
	@$(call add,THE_PACKAGES,gcodeworkshop)
endif

ifeq (distro,$(IMAGE_CLASS))
distro/regular-cnc-rt: distro/.regular-wm mixin/cnc-rt; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/regular-cnc-rt: vm/systemd vm/.regular-desktop mixin/vm-archdep mixin/cnc-rt; @:
endif
