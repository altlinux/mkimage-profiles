# this makefile is designed to be included in toplevel one

SYMLINK = build

# this could have come from environment;
# if not, can be symlinked if r/w, or made anew
# NB: immediate assignment matters
# NB: PATH has no effect here
ifndef BUILDDIR
BUILDDIR := $(shell [ -s "$(SYMLINK)" ] \
        && realpath "$(SYMLINK)" \
        || bin/mktmpdir mkimage-profiles.build)
endif

# even smart caching only hurts when every build goes from scratch
NO_CACHE ?= 1

PATH := $(CURDIR)/bin:$(PATH)

export BUILDDIR NO_CACHE PATH

# holds a postprocessor; shell test executes in particular situation
# NB: not exported, for toplevel use only
SHORTEN = $(shell [ "$(DEBUG)" != 2 -a -s "$(SYMLINK)" ] \
	  && echo "| sed 's,$(BUILDDIR),$(SYMLINK),'")

# step 1: initialize the off-tree mkimage profile (BUILDDIR)
profile/init: distclean
	@echo -n "** initializing BUILDDIR: "
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@:> "$(BUILDDIR)"/distcfg.mk
	@{ \
		git show-ref --head -d -s -- HEAD && \
		git status -s && \
		echo; \
	} $(LOG)
	@mkdir "$(BUILDDIR)"/.mki	# mkimage toplevel marker
	@type -t git >&/dev/null && \
		cd $(BUILDDIR) && \
		git init -q && \
		git add . && \
		git commit -qam 'distribution profile initialized'
	@rm -f "$(SYMLINK)" && \
		if [ -w . ]; then \
			ln -sf "$(BUILDDIR)" "$(SYMLINK)" && \
			echo "$(SYMLINK)/"; \
		else \
			echo "$(BUILDDIR)/"; \
		fi

# requires already formed distcfg.mk for useful output
profile/dump-vars:
	@if [ -s "$(SYMLINK)" ]; then \
		$(MAKE) --no-print-directory -C "$(SYMLINK)/" -f vars.mk; \
		echo; \
	fi $(LOG)

# step 3 entry point: copy the needed parts into BUILDDIR
profile/populate: profile/init distro/.rc profile/dump-vars
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir $(LOG); \
	done
