# collect what's left

all: reports/targets

reports/targets:
	@if ! [ -n "$$REPORT_PATH" -a -s "$$REPORT_PATH" ]; then \
		exit 0; \
	fi; \
	BUILDDIR="`sed -n 's/^.* BUILDDIR = \(.*\)/\1/p' "$$REPORT_PATH"`"; \
	if type -t dot >&/dev/null; then \
		REPORT_IMAGE="$$BUILDDIR/targets.png"; \
		report-targets < "$$REPORT_PATH" \
		| dot -Tpng -o "$$REPORT_IMAGE" \
		&& echo "** target graph report: $$REPORT_IMAGE"; \
	else \
		REPORT_DOT="$$BUILDDIR/targets.dot"; \
		report-targets < "$$REPORT_PATH" > "$$REPORT_DOT" \
		&& echo "** graphviz missing, target graph dot file: $$REPORT_DOT"; \
	fi && mv "$$REPORT_PATH" "$$BUILDDIR/targets.log"
