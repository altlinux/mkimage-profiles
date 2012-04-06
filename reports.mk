# collect what's left

all: reports/targets

reports/targets:
	@if [ -n "$$REPORT_PATH" -a -s "$$REPORT_PATH" ]; then \
		BUILDDIR="`sed -n 's/^.* BUILDDIR = \(.*\)/\1/p' \
			"$$REPORT_PATH"`"; \
		REPORT_IMAGE="$$BUILDDIR/targets.png"; \
		report-targets < "$$REPORT_PATH" \
		| dot -Tpng -o "$$REPORT_IMAGE" \
		&& echo "** target graph report: $$REPORT_IMAGE" \
		&& mv "$$REPORT_PATH" "$$BUILDDIR/targets.log"; \
	fi
