# this makefile is designed to be included in toplevel one

# this could have come from environment;
# if not, can be symlinked if r/w, or made anew
# NB: immediate assignment
ifndef BUILDDIR
BUILDDIR := $(shell [ -s build ] \
        && realpath build \
        || bin/mktmpdir mkimage-profiles.build)
endif

# holds a postprocessor; shell test executes in particular situation
# NB: not exported, for toplevel use only
SHORTEN = $(shell [ "$(DEBUG)" != 2 -a -s build ] \
	  && echo "| sed 's,$(BUILDDIR),build,'")

# even smart caching only hurts when every build goes from scratch
NO_CACHE ?= 1

export BUILDDIR NO_CACHE

# step 1: initialize the off-tree mkimage profile (BUILDDIR)
profile/init: distclean
	@echo -n "** initializing BUILDDIR: "
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@:> "$(BUILDDIR)"/distcfg.mk
	@{ \
		git show-ref --head -d -s -- HEAD && \
		git status -s && \
		echo; \
	} 2>/dev/null >> "$(BUILDLOG)"
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
