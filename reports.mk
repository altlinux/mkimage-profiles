# collect what's left

ifneq (,$(REPORT))

include lib/common.mk

BUILDDIR := $(shell sed -n 's/^.* BUILDDIR = \(.*\)/\1/p' "$(REPORT_PATH)")
BUILDLOG := $(BUILDDIR)/$(BUILD_LOG)
REPORTDIR := $(BUILDDIR)/reports/
IMAGE_OUTPATH := $(shell sed -n 's/^IMAGE_OUTPATH = \(.*\)/\1/p' $(BUILDLOG))

# for a multi-image build there's no sense to refer to buildroot
# contained reports as these are very ephemeral between builds
ifneq (1,$(NUM_TARGETS))
SHORTEN := >/dev/null
endif

all: reports/targets reports/scripts
	@cp -a $(REPORTDIR) $(IMAGE_OUTPATH).reports

reports/prep:
	@mkdir -p "$(REPORTDIR)"

reports/scripts: reports/prep
	@grep "^mki.*scripts: Run: " $(BUILDLOG) \
	| sed -rn "s,^.*($(BUILDDIR)|$(SYMLINK))/(.*)'$$,\2,p" \
	> "$(REPORTDIR)/$*.log" \
	&& echo "** scripts report: $(BUILDDIR)/$(@F).log" $(SHORTEN)

reports/targets: reports/prep
	@if ! [ -n "$(REPORT_PATH)" -a -s "$(REPORT_PATH)" ]; then \
		exit 0; \
	fi; \
	if type -t dot >&/dev/null; then \
		REPORT_IMAGE="$(BUILDDIR)/$@.png"; \
		report-targets < "$(REPORT_PATH)" \
		| dot -Tpng -o "$$REPORT_IMAGE" \
		&& echo "** target graph report: $$REPORT_IMAGE"; \
	else \
		REPORT_DOT="$(BUILDDIR)/targets.dot"; \
		report-targets < "$(REPORT_PATH)" > "$$REPORT_DOT" \
		&& echo "** graphviz missing, " \
			"target graph dot file: $$REPORT_DOT"; \
	fi $(SHORTEN); \
	mv "$(REPORT_PATH)" "$(REPORTDIR)/$(@F).log"

else
all:; @:
endif
