# step 3: copy package lists referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)
ifeq (,$(BUILDDIR))
pkgdups:
	@find -type f ! -name README ! -name Makefile \
	| grep -v '~$$' \
	| sed 's,^\./,,g' \
	| xargs ../../bin/pkgdups

%:
	$(error BUILDDIR not defined)

else

include $(BUILDDIR)/distcfg.mk
include $(BUILDDIR)/functions.mk

SUFFIX := pkg/lists
TARGET := $(BUILDDIR)/$(SUFFIX)

all: | $(TARGET) $(GLOBAL_DEBUG) copy-lists copy-groups save_packages_to_lists grep-kflavours grep-metadep grep-archdep check-lists
	@mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"

# env | grep _LISTS | sort -u | xargs -r cp -t
copy-lists:
	@echo $(sort $(foreach V, \
		$(filter %_LISTS,$(.VARIABLES)), \
		$(if $(filter environment% file,$(origin $V)),$($V)))) \
	|xargs -r -- cp --parents -at $(TARGET) -- || exit 1; \
	find $(TARGET) -name 'README' -delete -o -name 'Makefile' -delete

save_packages_to_lists:
	@$(foreach V, \
		$(filter-out NO_SORT_% CLEANUP_% %CLEANUP_PACKAGES GLOBAL_% PINNED_%,$(filter %_PACKAGES,$(sort \
		$(.VARIABLES)))),echo $($V) | sed -e 's/\s\+/\n/g' \
		| sort -u > $(TARGET)/$V;)

check-lists:
	@APTBOX=$(BUILDDIR)/.work/pkgbox/aptbox; \
	if [ -d "$$APTBOX" ]; then \
		check-pkg-list --aptbox "$$APTBOX" `find $(TARGET) -type f`; \
	fi
	@rm -f $(TARGET)/*_PACKAGES*

copy-groups: PKGDIR = ..
copy-groups:
	@echo $(sort $(call groups2lists)) \
	| xargs -r -- cp --parents -at $(TARGET) -- || exit 1

grep-archdep:
	@find $(TARGET) -type f \
	| xargs -r -I __ -- archdep-filter -a "$(ARCH)" -i __

grep-metadep:
	@APT_CACHE=$(BUILDDIR)/.work/pkgbox/aptbox/apt-cache; \
	if [ -f "$$APT_CACHE" ]; then \
		find $(TARGET) -type f \
		| xargs -r -I __ -- metadep-expander "$$APT_CACHE" __; \
	fi

grep-kflavours:
	@find $(TARGET) -type f \
	| xargs -r -I __ -- kflavours-expander "$(KFLAVOURS)" __

# do beforehand as foreach gets expanded before recipe execution
$(TARGET):
	@mkdir -p $(TARGET)

# figure out *_LISTS variables and print them out nicely
debug:
	@echo -e $(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell echo '\\n"**"' $V: $($V)))) '\n'

endif
