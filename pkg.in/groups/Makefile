# step 3: copy package groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/groups
TARGET := $(BUILDDIR)/$(SUFFIX)

all: $(GLOBAL_DEBUG)
	@if [ -n "$(MAIN_GROUPS)" ]; then \
		mkdir -p $(TARGET) && \
		cp -at $(TARGET) -- $(addsuffix .directory,$(MAIN_GROUPS)); \
		type -t git >&/dev/null && \
		cd $(TARGET) && \
		git add . && \
		git commit -qam "requested $(SUFFIX) copied over"; \
		cd - >&/dev/null; \
	fi

debug:
	@echo "** MAIN_GROUPS: $(MAIN_GROUPS)"
