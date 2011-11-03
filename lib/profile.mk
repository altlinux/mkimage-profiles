ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

SYMLINK = build

# this could have come from environment;
# if not, can be symlinked if r/w, or made anew
# NB: immediate assignment matters
# NB: PATH has no effect here
ifndef BUILDDIR
BUILDDIR := $(shell [ -s "$(SYMLINK)" ] \
        && realpath "$(SYMLINK)" \
        || bin/mktmpdir mkimage-profiles)
endif

# even smart caching only hurts when every build goes from scratch
NO_CACHE ?= 1

PATH := $(CURDIR)/bin:$(PATH)

export BUILDDIR NO_CACHE PATH

CONFIG := $(BUILDDIR)/distcfg.mk
RC := $(HOME)/.mkimage/profiles.mk

# holds a postprocessor; shell test executes in particular situation
# NB: not exported, for toplevel use only
SHORTEN = $(shell \
		if [ -s "$(SYMLINK)" ]; then \
			echo "| sed 's,$(BUILDDIR),$(SYMLINK),'"; \
		else \
			echo "| sed 's,$(TMP),\$$TMP,'"; \
		fi;)

# step 1: initialize the off-tree mkimage profile (BUILDDIR)
profile/init: distclean
	@echo -n "** initializing BUILDDIR: "
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/
	@mkdir "$(BUILDDIR)"/.mki	# mkimage toplevel marker
	@$(call put,ifndef DISTCFG_MK)
	@$(call put,DISTCFG_MK = 1)
	@if type -t git >&/dev/null; then \
		if [ -d .git ]; then \
			git show-ref --head -d -s -- HEAD && \
			git status -s && \
			echo; \
		fi $(LOG); \
	fi
	@{ \
		eval `apt-config shell $${APTCONF:+-c=$(wildcard $(APTCONF))} \
			SOURCELIST Dir::Etc::sourcelist/f \
			SOURCEPARTS Dir::Etc::sourceparts/d`; \
		find "$$SOURCEPARTS" -name '*.list' \
		| xargs egrep -Rhv '^#|^[[:blank:]]*$$' "$$SOURCELIST" && \
		echo; \
	} $(LOG)
	@if type -t git >&/dev/null; then \
		if cd $(BUILDDIR); then \
			git init -q && \
			git add . && \
			git commit -qam 'derivative profile initialized'; \
		fi; \
	fi
	@if [ -w . ]; then \
		rm -f "$(SYMLINK)" && \
		ln -sf "$(BUILDDIR)" "$(SYMLINK)" && \
		echo "$(SYMLINK)/"; \
	else \
		echo "$(BUILDDIR)/" $(SHORTEN); \
	fi $(SHORTEN)

profile/bare: profile/init
	@echo "** preparing distro config$${DEBUG:+: see $(CONFIG)}" \
		$(SHORTEN)
	@$(call try,MKIMAGE_PREFIX,/usr/share/mkimage)
	@$(call try,GLOBAL_VERBOSE,)
	@$(call try,IMAGEDIR,$(IMAGEDIR))
	@$(call try,BRANDING,altlinux-sisyphus)
	@$(call set,IMAGE_INIT_LIST,+branding-$$(BRANDING)-release)
	@if type -t git >&/dev/null && cd $(BUILDDIR); then \
		git init -q && \
		git add . && \
		git commit -qam 'image configuration defaults set'; \
	fi

profile/finalize:
	@if [ -s $(RC) ]; then $(call put,-include $(RC)); fi
	@$(call put,endif)
	@if type -t git >&/dev/null && cd $(BUILDDIR); then \
		git init -q && \
		git add . && \
		git commit -qam 'image configuration finalized'; \
	fi

# requires already formed distcfg.mk for useful output
profile/dump-vars:
	@if [ -s "$(SYMLINK)" ]; then \
		$(MAKE) --no-print-directory -C "$(SYMLINK)/" -f vars.mk; \
		echo; \
	fi $(LOG)

# step 3 entry point: copy the needed parts into BUILDDIR
profile/populate: profile/init profile/finalize profile/dump-vars
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir $(LOG); \
	done
