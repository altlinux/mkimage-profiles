# this makefile is designed to be included in toplevel one
ifdef BUILDDIR

# step 1: initialize the off-tree mkimage profile
profile/init: distclean
	@echo -n "** initializing BUILDDIR: "
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@:> "$(BUILDDIR)"/.config.mk
	@:> "$(BUILDLOG)"
	@mkdir "$(BUILDDIR)"/.mki	# mkimage toplevel marker
	@type -t git >&/dev/null && \
		cd $(BUILDDIR) && \
		git init -q && \
		git add . && \
		git commit -qam 'init'
	@rm -f build
	@if [ -w . ]; then \
		ln -sf "$(BUILDDIR)" build && \
		echo "build/"; \
	else \
		echo "$(BUILDDIR)/"; \
	fi

# this is done after step 2, see toplevel Makefile
profile/populate: profile/init distro/.metaconf
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir $(LOG); \
	done

endif
