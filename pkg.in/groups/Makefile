# step 3: copy package groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

include $(BUILDDIR)/.config.mk

all: debug
	@[ -n "$(GROUPS)" ] && { \
		mkdir -p $(BUILDDIR)/pkg/groups && \
		cp -at $(BUILDDIR)/pkg/groups/ -- $(addsuffix .directory,$(GROUPS)); \
	} ||:

debug:
	@echo "** GROUPS: $(GROUPS)"
