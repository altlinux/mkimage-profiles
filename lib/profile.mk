ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

# this could have come from env; or could be symlinked; or is made anew
# (the reuse rationale is avoiding extra tmpdir lookups)
# NB: immediate assignment matters
ifndef BUILDDIR
BUILDLINK := $(realpath $(SYMLINK))
BUILDDIR  := $(shell \
if [ -s "$(SYMLINK)" -a "$(NUM_TARGETS)" = 1 ] && \
   [ -n "$(findstring $(BUILDDIR_PREFIX).,$(BUILDLINK))" ]; \
then \
	echo "$(BUILDLINK)"; \
else \
	mktmpdir $(BUILDDIR_PREFIX) || exit 200; \
fi; )
endif

ifeq (,$(BUILDDIR))
$(error suitable BUILDDIR unavailable)
endif

# even smart caching only hurts when every build goes from scratch
NO_CACHE ?= 1

export BUILDDIR NO_CACHE

CONFIG := $(BUILDDIR)/distcfg.mk
RC := $(HOME)/.mkimage/profiles.mk

# step 1: initialize the off-tree mkimage profile (BUILDDIR)
# NB: our output MUST go into stderr to escape POSTPROC
profile/init: distclean
	@{ \
	if [ "`realpath "$(BUILDDIR)/"`" = / ]; then \
		echo "$(TIME) ERROR: invalid BUILDDIR: \`$(BUILDDIR)'"; \
		exit 128; \
	fi; \
	echo -n "$(TIME) initializing BUILDDIR: "; \
	rsync -qaxH --delete-after image.in/ "$(BUILDDIR)"/; \
	mkdir "$(BUILDDIR)"/.mki; \
	} >&2
	@$(call put,ifndef DISTCFG_MK)
	@$(call put,DISTCFG_MK = 1)
	@{ \
	if type -t git >&/dev/null; then \
		if [ -d .git ]; then \
			git show-ref --head -d -s -- HEAD && \
			git status -s && \
			echo; \
		fi $(LOG); \
	fi; \
	{ \
		eval `apt-config shell $${APTCONF:+-c=$(wildcard $(APTCONF))} \
			SOURCELIST Dir::Etc::sourcelist/f \
			SOURCEPARTS Dir::Etc::sourceparts/d`; \
		find "$$SOURCEPARTS" -name '*.list' \
		| xargs egrep -Rhv '^#|^[[:blank:]]*$$' "$$SOURCELIST" && \
		echo; \
	} $(LOG); \
	if type -t git >&/dev/null; then \
		if cd $(BUILDDIR); then \
			git init -q && \
			git add . && \
			git commit -qam 'derivative profile initialized'; \
			cd ->&/dev/null; \
		fi; \
	fi; \
	if [ -w . ]; then \
		rm -f "$(SYMLINK)" && \
		ln -s "$(BUILDDIR)" "$(SYMLINK)" && \
		echo "$(SYMLINK)/"; \
	else \
		echo "$(BUILDDIR)/"; \
	fi $(SHORTEN); \
	} >&2

profile/bare: profile/init
	@{ \
	NOTE="$${GLOBAL_VERBOSE:+: $(CONFIG)}"; \
	echo "$(TIME) preparing distro config$$NOTE" $(SHORTEN); \
	} >&2
	@$(call try,MKIMAGE_PREFIX,/usr/share/mkimage)
	@$(call try,GLOBAL_VERBOSE,)
	@$(call try,IMAGEDIR,$(IMAGEDIR))
	@$(call try,LOGDIR,$(LOGDIR))
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
profile/populate: profile/finalize profile/dump-vars
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir $(LOG); \
	done
