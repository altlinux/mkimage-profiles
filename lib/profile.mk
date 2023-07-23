ifeq (,$(MKIMAGE_PROFILES))
$(error this makefile is designed to be included in toplevel one)
endif

ifneq (,$(filter-out $(DIRECT_TARGETS),$(MAKECMDGOALS)))
# this could have come from env; or could be symlinked; or is made anew
# (the reuse rationale is avoiding extra tmpdir lookups)
# NB: immediate assignment matters
ifeq (,$(BUILDDIR))
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
endif

# even smart caching only hurts when every build goes from scratch
NO_CACHE ?= 1

export BUILDDIR NO_CACHE

CONFIG := $(BUILDDIR)/distcfg.mk
RC = $(HOME)/.mkimage/profiles.mk

# step 1: initialize the off-tree mkimage profile (BUILDDIR)
# NB: our output MUST go into stderr to escape POSTPROC
profile/init: $(shell [ -L $(BUILDDIR) ] || echo distclean)
	@{ \
	if [ "`realpath "$(BUILDDIR)/"`" = / ]; then \
		echo "$(TIME) ERROR: invalid BUILDDIR: \`$(BUILDDIR)'"; \
		exit 128; \
	fi; \
	if [ -z "$(QUIET)" ]; then \
		echo -n "$(TIME) initializing BUILDDIR: "; \
	fi; \
	rsync -qaxH --delete-after image.in/ "$(BUILDDIR)"/; \
	mkdir "$(BUILDDIR)"/.mki; \
	} >&2
	@$(call put,ifndef DISTCFG_MK)
	@$(call put,DISTCFG_MK = 1)
	@{ \
	mp-showref $(LOG); \
	{ \
		APTCONF="$(wildcard $(APTCONF))"; \
		echo "** using $${APTCONF:-system apt configuration}:"; \
		eval `apt-config shell $${APTCONF:+-c=$$APTCONF} \
			SOURCELIST Dir::Etc::sourcelist/f \
			SOURCEPARTS Dir::Etc::sourceparts/d`; \
		find "$$SOURCEPARTS" -mindepth 1 -maxdepth 1 -name '*.list' \
		| xargs grep -E -hv -e '^#|^[[:blank:]]*$$' -- "$$SOURCELIST" \
		| tee $(BUILDDIR)/sources.list; \
		echo; \
	} $(LOG); \
	if ! grep -q "\<$(ARCH)\>" $(BUILDDIR)/sources.list; then \
		if grep -q " noarch " $(BUILDDIR)/sources.list; then \
			echo -n "requested arch '$$ARCH' unavailable" >&2; \
			if [ -z "$(APTCONF)" ]; then \
				echo " (no APTCONF)"; \
			else \
				echo; \
			fi >&2; \
			[ "$(CHECK)" = 0 ] || exit 1; \
		fi; \
	fi; \
	if type -t git >&/dev/null && [ -d .git ]; then \
		git show -s --format=%H > "$(BUILDDIR)"/commit; \
	fi; \
	mp-commit -i "$(BUILDDIR)" "derivative profile initialized"; \
	if [ -w . -a ! -L "$(BUILDDIR)" ]; then \
		rm -f "$(SYMLINK)" && \
		ln -s "$(BUILDDIR)" "$(SYMLINK)" && \
		if [ -z "$(QUIET)" ]; then \
			echo "$(SYMLINK)/"; \
		fi; \
	else \
		if [ -z "$(QUIET)" ]; then \
			echo "$(BUILDDIR)/"; \
		fi; \
	fi $(SHORTEN); \
	} >&2

profile/bare: profile/init use/pkgpriorities
	@{ \
	NOTE="$${GLOBAL_VERBOSE:+: $(CONFIG)}"; \
	if [ -z "$(QUIET)" ]; then \
		echo "$(TIME) preparing distro config$$NOTE" $(SHORTEN); \
	fi; \
	} >&2
	@$(call try,MKIMAGE_PREFIX,/usr/share/mkimage)
	@$(call try,GLOBAL_PREFIX,$(MKIMAGE_PREFIX))
	@$(call try,GLOBAL_VERBOSE,)
	@$(call try,IMAGEDIR,$(wildcard $(IMAGEDIR)))
	@$(call try,LOGDIR,$(wildcard $(LOGDIR)))
ifeq (sisyphus,$(BRANCH))
	@$(call try,BRANDING,alt-sisyphus)
else
	@$(call try,BRANDING,alt-starterkit)
endif
	@$(call set,GLOBAL_HSH_PROC,1)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-alterator:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-bootsplash:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-bootloader:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-graphics:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-indexhtml:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-notes:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-release:Essential)
	@$(call add,PINNED_PACKAGES,branding-$$(BRANDING)-slideshow:Essential)
	@$(call set,PACKAGES_REQUIRED_INITROOT,basesystem branding-$$(BRANDING)-release)
	@$(call xport,ARCH)
	@mp-commit "$(BUILDDIR)" "image configuration defaults set"

# put the derived SUBPROFILE_DIRS here to get it logged in clear text by the way
profile/finalize:
	@$(call put,SUBPROFILE_DIRS = $$(notdir $$(subst @,/,$$(SUBPROFILES))))
	@if [ -s "$(RC)" ]; then $(call put,-include $(value RC)); fi
	@$(call put,endif)
	@mp-commit "$(BUILDDIR)" "image configuration finalized"

# requires already formed distcfg.mk for useful output
profile/dump-vars:
	@if [ -s "$(SYMLINK)" ]; then \
		$(MAKE) --no-print-directory -C "$(SYMLINK)/" -f vars.mk; \
		echo; \
	fi $(LOG)

# step 3 entry point: copy the needed parts into BUILDDIR
profile/populate: SHELL=/bin/bash
profile/populate: profile/finalize profile/dump-vars make-aptbox
	@for dir in sub.in features.in pkg.in; do \
		$(MAKE) -C $$dir $(LOG_STDERR); \
	done
