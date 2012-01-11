# umbrella mkimage-profiles makefile:
# iterate over multiple goals/arches

# immediate assignment
ifndef ARCHES
ifdef ARCH
ARCHES := $(ARCH)
else
ARCHES := $(shell arch | sed 's/i686/i586/')
endif
endif
export ARCHES

# recursive make considered useful for m-p
MAKE += --no-print-directory

.PHONY: clean distclean help
clean distclean help:
	@$(MAKE) -f main.mk $@

export NUM_TARGETS := $(words $(MAKECMDGOALS))

# real targets need real work
%:
	@n=1; \
	if [ "$(NUM_TARGETS)" -gt 1 ]; then \
		n="`echo $(MAKECMDGOALS) \
		| tr '[[:space:]]' '\n' \
		| grep -nx "$@" \
		| cut -d: -f1`"; \
		echo "** goal: $@ [$$n/$(NUM_TARGETS)]"; \
	fi; \
	for ARCH in $(ARCHES); do \
		$(MAKE) -f main.mk ARCH=$$ARCH $@; \
	done; \
	if [ "$$n" -lt "$(NUM_TARGETS)" ]; then echo; fi
