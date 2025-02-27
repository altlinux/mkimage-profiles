ifeq (distro,$(IMAGE_CLASS))
distro/regular-engineering-live: distro/.regular-x11 +systemd +systemd-optimal \
	mixin/regular-desktop mixin/regular-gnome use/x11/gdm  \
	use/l10n +nm-gtk4 +plymouth \
	use/live/ru use/live/rw use/live/desktop \
	use/cleanup/live-no-cleanupdb \
	use/cleanup/live-no-cleanup-docs
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

endif
