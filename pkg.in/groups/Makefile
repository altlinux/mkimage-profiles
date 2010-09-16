# copy package lists referenced in distro configuration
# over to build dir

include $(BUILDDIR)/.config.mk

all: debug
	@mkdir -p $(BUILDDIR)/pkg/groups \
	&& cp -at $(BUILDDIR)/pkg/groups/ -- $(addsuffix .directory,$(GROUPS))

debug:
	@echo "** GROUPS: $(GROUPS)"
