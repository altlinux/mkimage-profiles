# umbrella mkimage-profiles makefile:
# iterate over multiple goals/arches,
# collect proceedings

ifeq (,$(CHECK))
ifeq (,$(DEBUG))
ifneq (,$(REPORT))
$(warning REPORT is disabled, DEBUG must be enabled for this)
endif
endif
endif

ifndef BRANCH
BRANCH := $(shell rpm --eval %_priority_distbranch | cut -d _ -f 1)
export BRANCH
endif

ifeq (,$(BRANCH))
override BRANCH=sisyphus
MAKEOVERRIDES += BRANCH=sisyphus
endif

# preferences
-include $(HOME)/.mkimage/profiles.mk

# for immediate assignment
ifeq (,$(ARCH))
ARCH := $(shell arch \
	| sed 's/i686/i586/; s/armv7.*/armh/; s/armv.*/arm/')
endif

ifeq (,$(ARCHES))
ARCHES := $(ARCH)
endif

export ARCHES ARCH

export PATH := $(CURDIR)/bin:$(PATH)

# recursive make considered useful for m-p
MAKE += -r --no-print-directory

export DIRECT_TARGETS := help help/distro help/ve help/vm clean distclean check
.PHONY: $(DIRECT_TARGETS)

# these build nothing so no use of reports either
$(DIRECT_TARGETS):
	@$(MAKE) -f main.mk REPORT= $@

export NUM_TARGETS := $(words $(MAKECMDGOALS))

# for pipefail
SHELL = /bin/bash

# don't even consider remaking a configuration file
.PHONY: $(HOME)/.mkimage/profiles.mk

# real targets need real work
%:
	@n=1; \
	set -o pipefail; \
	say() { echo "$$@" >&2; }; \
	if [ "$(NUM_TARGETS)" -gt 1 ]; then \
		n="`echo $(MAKECMDGOALS) \
		| tr '[[:space:]]' '\n' \
		| grep -nx "$@" \
		| cut -d: -f1`"; \
		say "** goal: $@ [$$n/$(NUM_TARGETS)]"; \
	else \
		say "** goal: $@"; \
	fi; \
	say "** BRANCH: $(BRANCH)"; \
	for ARCH in $(ARCHES); do \
		if [ -z "$(QUIET)" ]; then \
			if [ "$$ARCH" != "$(firstword $(ARCHES))" ]; then \
				say; \
			fi; \
			say "** ARCH: $$ARCH"; \
		fi; \
		if [ -n "$(REPORT)" ] && [ -n "$(DEBUG)" ] && [ -z "$(CHECK)" ]; then \
			REPORT_PATH=$$(mktemp --tmpdir mkimage-profiles.report.XXXXXXX); \
			$(MAKE) -f main.mk ARCH=$$ARCH $@ | report-filter > $$REPORT_PATH || exit 1; \
			$(MAKE) -f reports.mk ARCH=$$ARCH REPORT=$(REPORT) REPORT_PATH=$$REPORT_PATH; \
		else \
			$(MAKE) -f main.mk ARCH=$$ARCH $@ || exit 1; \
		fi; \
		if [ -n "$(AUTOCLEAN)" ]; then $(MAKE) distclean; fi; \
	done; \
	if [ "$$n" -lt "$(NUM_TARGETS)" ]; then say; fi

docs:
	@$(MAKE) -C doc

docs-publish:
	@$(MAKE) -C doc publish
