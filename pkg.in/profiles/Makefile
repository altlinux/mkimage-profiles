# step 3: copy package profiles referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/profiles
TARGET := $(BUILDDIR)/$(SUFFIX)

all: | $(TARGET) $(GLOBAL_DEBUG) copy-profiles grep-archdep
	@mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"

copy-profiles:
	@if [ -n "$(THE_PROFILES)" ]; then \
		cp --parents -at $(TARGET) -- \
			$(addsuffix .directory,$(THE_PROFILES)); \
	fi

grep-archdep:
	@find $(TARGET) -type f \
	| xargs -r -I __ -- archdep-filter -a "$(ARCH)" -i __

$(TARGET):
	@mkdir -p $(TARGET)

debug:
	@echo "** THE_PROFILES: $(THE_PROFILES)"
