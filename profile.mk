profile/init:
	@echo "** BUILDDIR: $(BUILDDIR)"
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@:> "$(BUILDDIR)"/.config.mk
	@mkdir "$(BUILDDIR)"/.mki	# mkimage toplevel marker
	@type -t git >&/dev/null && \
		cd $(BUILDDIR) && \
		git init -q && \
		git add . && \
		git commit -qam 'init'
	@rm -f build
	@if [ -w . ]; then \
		ln -sf "$(BUILDDIR)" build; \
	else \
		echo "** profile directory readonly: skipping symlinks, env only"; \
	fi

profile/populate: profile/init distro/.metaconf
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir; \
	done

