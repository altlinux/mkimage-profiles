ifdef BUILDDIR

include $(BUILDDIR)/distcfg.mk

# prepare the provided public SSH key to be carried over into the image
all: SSH_DIR = $(BUILDDIR)/files/root/.ssh
all:
	@if [ -s "$(SSH_KEY)" ]; then \
		mkdir -pm0700 "$(SSH_DIR)"; \
		install -pm0600 "$(SSH_KEY)" "$(SSH_DIR)/authorized_keys"; \
	fi

endif
