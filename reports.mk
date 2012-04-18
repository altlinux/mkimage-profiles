# collect what's left

BUILDDIR := $(shell sed -n 's/^.* BUILDDIR = \(.*\)/\1/p' "$$REPORT_PATH")

include lib/common.mk

all: reports/targets reports/scripts

reports/prep:
	@if ! [ -n "$$REPORT_PATH" -a -s "$$REPORT_PATH" ]; then \
		exit 0; \
	fi; \
	mkdir -p "$(BUILDDIR)/reports/"

reports/scripts: reports/prep
	@grep "^mki.*scripts: Run: " $(BUILDDIR)/$(BUILD_LOG) \
	| sed -rn "s,^.*($(BUILDDIR)|$(SYMLINK))/(.*)'$$,\2,p" \
	> "$(BUILDDIR)/$@.log" \
	&& echo "** scripts report: $(BUILDDIR)/$@.log" $(SHORTEN)

reports/targets: reports/prep
	@if type -t dot >&/dev/null; then \
		REPORT_IMAGE="$(BUILDDIR)/$@.png"; \
		report-targets < "$$REPORT_PATH" \
		| dot -Tpng -o "$$REPORT_IMAGE" \
		&& echo "** target graph report: $$REPORT_IMAGE"; \
	else \
		REPORT_DOT="$(BUILDDIR)/targets.dot"; \
		report-targets < "$$REPORT_PATH" > "$$REPORT_DOT" \
		&& echo "** graphviz missing, " \
			"target graph dot file: $$REPORT_DOT"; \
	fi $(SHORTEN); \
	mv "$$REPORT_PATH" "$(BUILDDIR)/$@.log"
