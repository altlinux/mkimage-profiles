# common bits for building and reporting parts

# somewhat reusable
BUILD_LOG = build.log

# link it to BUILDDIR if possible
SYMLINK = build

# brevity postprocessor; not exported, for toplevel use only
SHORTEN = $(shell \
	echo -n "| sed"; \
	if [ -s "$(SYMLINK)" ]; then \
		echo -n " -e 's,$(BUILDDIR),$(SYMLINK),'"; \
	fi; \
	echo -n " -e 's,$(TMP),\$$TMP,' -e 's,$(HOME),~,'"; \
)
