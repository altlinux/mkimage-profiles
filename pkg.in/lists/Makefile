# step 3: copy package lists referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
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

all: | $(TARGET) $(GLOBAL_DEBUG) copy-lists copy-groups save_packages_to_lists grep-metadep grep-archdep check-lists
	@mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"

# env | sort -u | grep _LISTS | xargs -r cp -t
copy-lists:
	@echo $(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),$($V))) \
	|xargs -r -- cp --parents -at $(TARGET) --; \
	find $(TARGET) -name 'README' -delete -o -name 'Makefile' -delete

save_packages_to_lists:
	@echo $(BASE_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/BASE_PACKAGES
	@echo $(BASE_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/BASE_PACKAGES_REGEXP
	@echo $(COMMON_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/COMMON_PACKAGES
	@echo $(COMMON_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/COMMON_PACKAGES_REGEXP
	@echo $(INSTALL2_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/INSTALL2_PACKAGES
	@echo $(INSTALL2_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/INSTALL2_PACKAGES_REGEXP
	@echo $(LIVE_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/LIVE_PACKAGES
	@echo $(LIVE_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/LIVE_PACKAGES_REGEXP
	@echo $(MAIN_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/MAIN_PACKAGES
	@echo $(MAIN_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/MAIN_PACKAGES_REGEXP
	@echo $(STAGE1_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/STAGE1_PACKAGES
	@echo $(STAGE1_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/STAGE1_PACKAGES_REGEXP
	@echo $(STAGE2_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/STAGE2_PACKAGES
	@echo $(STAGE2_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/STAGE2_PACKAGES_REGEXP
	@echo $(SYSTEM_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/SYSTEM_PACKAGES
	@echo $(SYSTEM_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/SYSTEM_PACKAGES_REGEXP
	@echo $(THE_PACKAGES) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/THE_PACKAGES
	@echo $(THE_PACKAGES_REGEXP) |sed -e 's/\s\+/\n/g' \
		|sort -u > $(TARGET)/THE_PACKAGES_REGEXP

check-lists:
	@APTBOX=$(BUILDDIR)/.work/pkgbox/aptbox; \
	if [ -d "$$APTBOX" ]; then \
		check-pkg-list --aptbox "$$APTBOX" `find $(TARGET) -type f`; \
	fi
	@rm -f $(TARGET)/*_PACKAGES*

copy-groups: PKGDIR = ..
copy-groups:
	@echo $(call groups2lists) \
	| xargs -r -- cp --parents -at $(TARGET) --

grep-archdep:
	@find $(TARGET) -type f \
	| xargs -r -I __ -- archdep-filter -a "$(ARCH)" -i __

grep-metadep:
	@APT_CACHE=$(BUILDDIR)/.work/pkgbox/aptbox/apt-cache; \
	if [ -f "$$APT_CACHE" ]; then \
		find $(TARGET) -type f \
		| xargs -r -I __ -- metadep-expander "$$APT_CACHE" __; \
	fi

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
