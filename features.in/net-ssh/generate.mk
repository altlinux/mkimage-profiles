ifneq (,$(BUILDDIR))

include $(BUILDDIR)/distcfg.mk

# prepare the provided public SSH key to be carried over into the image
all: TMPDIR = $(BUILDDIR)/files/tmp
all:
	@if [ -s "$(SSH_KEY)" ]; then \
		mkdir -p "$(TMPDIR)"; \
		cp -v "$(SSH_KEY)" "$(TMPDIR)/root_ssh_key.pub"; \
	fi

endif
