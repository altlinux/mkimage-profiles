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

all: | $(TARGET) $(GLOBAL_DEBUG) copy-lists copy-groups grep-archdep
	@mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"

# env | sort -u | grep _LISTS | xargs -r cp -t
copy-lists:
	@echo $(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),$($V))) \
	| xargs -r -- cp --parents -at $(TARGET) --

copy-groups: PKGDIR = ..
copy-groups:
	@echo $(call groups2lists) \
	| xargs -r -- cp --parents -at $(TARGET) --

grep-archdep:
	@find $(TARGET) -type f \
	| xargs -r -I __ -- archdep-filter -a "$(ARCH)" -i __

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
