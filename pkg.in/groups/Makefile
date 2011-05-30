# step 3: copy package groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/groups
TARGET := $(BUILDDIR)/$(SUFFIX)

all: debug
	@if [ -n "$(GROUPS)" ]; then \
		mkdir -p $(TARGET) && \
		cp -at $(TARGET) -- $(addsuffix .directory,$(GROUPS)); \
		type -t git >&/dev/null && \
		cd $(TARGET) && \
		git add . && \
		git commit -qam "$(SUFFIX)"; \
		cd - >&/dev/null; \
	fi

debug:
ifdef GLOBAL_VERBOSE
	@echo "** GROUPS: $(GROUPS)"
endif
