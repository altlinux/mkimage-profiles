# step 3: copy package profiles referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/profiles
TARGET := $(BUILDDIR)/$(SUFFIX)

all: $(GLOBAL_DEBUG)
	@if [ -n "$(PKG_PROFILES)" ]; then \
		mkdir -p $(TARGET) && \
		cp -at $(TARGET) -- \
			$(addsuffix .directory,$(PKG_PROFILES)); \
		mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"; \
	fi

debug:
	@echo "** PKG_PROFILES: $(PKG_PROFILES)"
