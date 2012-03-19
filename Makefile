# umbrella mkimage-profiles makefile:
# iterate over multiple goals/arches,
# collect proceedings

# for immediate assignment
ifndef ARCHES
ifdef ARCH
ARCHES := $(ARCH)
else
ARCHES := $(shell arch | sed 's/i686/i586/')
endif
endif
export ARCHES

# supervise target tracing; leave stderr alone
ifdef REPORT
export REPORT_PATH := $(shell mktemp --tmpdir mkimage-profiles.report.XXXXXXX)
POSTPROC := | bin/report-filter > $(REPORT_PATH)
endif

# recursive make considered useful for m-p
MAKE += -r --no-print-directory

.PHONY: clean distclean help
clean distclean help:
	@$(MAKE) -f main.mk $@

export NUM_TARGETS := $(words $(MAKECMDGOALS))

# real targets need real work
%:
	@n=1; \
	say() { echo "$$@" >&2; }; \
	if [ "$(NUM_TARGETS)" -gt 1 ]; then \
		n="`echo $(MAKECMDGOALS) \
		| tr '[[:space:]]' '\n' \
		| grep -nx "$@" \
		| cut -d: -f1`"; \
		say "** goal: $@ [$$n/$(NUM_TARGETS)]"; \
	fi; \
	for ARCH in $(ARCHES); do \
		if [ "$$ARCH" != "$(firstword $(ARCHES))" ]; then say; fi; \
		say "** ARCH: $$ARCH" >&2; \
		$(MAKE) -f main.mk ARCH=$$ARCH $@ $(POSTPROC); \
		$(MAKE) -f reports.mk ARCH=$$ARCH; \
	done; \
	if [ "$$n" -lt "$(NUM_TARGETS)" ]; then say; fi
