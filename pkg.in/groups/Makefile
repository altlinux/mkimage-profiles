# step 3: copy package groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/groups
TARGET := $(BUILDDIR)/$(SUFFIX)

all: $(GLOBAL_DEBUG)
	@if [ -n "$(THE_GROUPS)$(MAIN_GROUPS)" ]; then \
		mkdir -p $(TARGET) && \
		cp -at $(TARGET) -- \
			$(addsuffix .directory,$(THE_GROUPS) $(MAIN_GROUPS)); \
		mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"; \
	fi

debug:
	@echo "** THE_GROUPS: $(THE_GROUPS)"
	@echo "** MAIN_GROUPS: $(MAIN_GROUPS)"
