ifeq (distro,$(IMAGE_CLASS))
distro/regular-engineering-live: distro/.regular-base +systemd \
	mixin/regular-gnome use/vmguest/base \
	use/l10n +nm-gtk4 +plymouth \
	use/live/ru use/live/rw use/live/desktop-common \
	use/cleanup/live-no-cleanupdb \
	use/cleanup/live-no-cleanup-docs
	@$(call set,LIVE_NAME,ALT Engineering $(BRANCH) Live)
	@$(call add,LIVE_LISTS,task-common/system-base)
	@$(call add,LIVE_LISTS,task-common/desktop-base)
	@$(call add,LIVE_LISTS,engineering/2d-cad)
	@$(call add,LIVE_LISTS,engineering/3d-cad)
	@$(call add,LIVE_LISTS,engineering/3d-printer)
	@$(call add,LIVE_LISTS,engineering/apcs)
	@$(call add,LIVE_LISTS,engineering/cam)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,LIVE_LISTS,engineering/cnc)
endif
	@$(call add,LIVE_LISTS,engineering/eda)
	@$(call add,LIVE_LISTS,engineering/misc)
	@$(call add,LIVE_PACKAGES,theme-gnome-windows)
	@$(call add,LIVE_PACKAGES,python3-module-pygobject3) # ALT bug 52950

endif
