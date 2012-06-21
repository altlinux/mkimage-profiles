ifdef BUILDDIR

include $(BUILDDIR)/distcfg.mk

# prepare the provided public SSH key to be carried over into the VM image
all: SSH_DIR = $(BUILDDIR)/files/root/.ssh
all:
	@if [ -s "$(SSH_KEY)" ]; then \
		install -pD "$(SSH_KEY)" "$(SSH_DIR)/authorized_keys"; \
	fi

endif
