profile/init:
	@echo "** BUILDDIR: $(BUILDDIR)"
#	ls -ld $(BUILDDIR)
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@touch "$(BUILDDIR)"/.config.mk
	@mkdir "$(BUILDDIR)"/.mki
	cd $(BUILDDIR); git init	###
	@rm -f build
	@[ -w . ] \
		&& ln -sf "$(BUILDDIR)" build \
		|| echo "** profile directory readonly: skipping symlinks, env only"

profile/populate: profile/init
	for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir; \
	done

