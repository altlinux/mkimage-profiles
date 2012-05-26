# common bits for building and reporting parts

# somewhat reusable
BUILD_LOG = build.log

# link it to BUILDDIR if possible
SYMLINK = build

# brevity postprocessor; not exported, for toplevel use only
SHORTEN = $(shell FILTER=; \
	if [ -s "$(SYMLINK)" ]; then \
		FILTER=" -e 's,$(BUILDDIR),$(SYMLINK),'"; \
	fi; \
	if [ -n "$$TMP" ]; then \
		FILTER="$$FILTER -e 's,$$TMP,\$$TMP,'"; \
	fi; \
	if [ -n "$$HOME" ]; then \
		FILTER="$$FILTER -e 's,$$HOME,~,'"; \
	fi; \
	if [ -n "$$FILTER" ]; then \
		echo -n "| sed $$FILTER"; \
	fi; \
)
