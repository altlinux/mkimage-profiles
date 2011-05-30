# this makefile is designed to be included in toplevel one
ifdef BUILDDIR

# step 1: initialize the off-tree mkimage profile (BUILDDIR)
profile/init: distclean
	@echo -n "** initializing BUILDDIR: "
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@:> "$(BUILDDIR)"/distcfg.mk
	@:> "$(BUILDLOG)"
	@mkdir "$(BUILDDIR)"/.mki	# mkimage toplevel marker
	@type -t git >&/dev/null && \
		cd $(BUILDDIR) && \
		git init -q && \
		git add . && \
		git commit -qam 'init'
	@rm -f build && \
		if [ -w . ]; then \
			ln -sf "$(BUILDDIR)" build && \
			echo "build/"; \
		else \
			echo "$(BUILDDIR)/"; \
		fi

# step 3 entry point: copy the needed parts into BUILDDIR
profile/populate: profile/init distro/.rc
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir $(LOG); \
	done

endif
