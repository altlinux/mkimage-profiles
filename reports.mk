# collect what's left

ifneq (,$(REPORT))

include lib/common.mk

BUILDDIR := $(shell sed -n 's/^.* BUILDDIR = \(.*\)/\1/p' "$(REPORT_PATH)")
BUILDLOG := $(BUILDDIR)/$(BUILD_LOG)
REPORTDIR := $(BUILDDIR)/reports
IMAGE_OUTPATH := $(shell sed -n 's/^IMAGE_OUTPATH = \(.*\)/\1/p' $(BUILDLOG))
IMAGE_OUTFILE := $(shell sed -n 's/^IMAGE_OUTFILE = \(.*\)/\1/p' $(BUILDLOG))
LOGDIR := $(shell sed -n 's/^LOGDIR = \(.*\)/\1/p' $(BUILDLOG))

# for a multi-image build there's no sense to refer to buildroot
# contained reports as these are very ephemeral between builds
ifneq (1,$(NUM_TARGETS))
SHORTEN := >/dev/null
endif

all: reports/targets reports/scripts
	@if [ -n "$(IMAGE_OUTPATH)" ]; then \
		cp -a "$(REPORTDIR)" "$(LOGDIR)/$(IMAGE_OUTFILE).reports"; \
	fi

reports/prep:
	@mkdir -p "$(REPORTDIR)"

reports/scripts: reports/prep
	@OUT="$(REPORTDIR)/$(@F).log"; \
	grep "^mki.*scripts: Run: " $(BUILDLOG) \
	| sed -rn "s,^.*($(BUILDDIR)|$(SYMLINK))/(.*)'$$,\2,p" > "$$OUT" \
	&& if [ -s "$$OUT" ]; then \
		echo "** scripts report: $$OUT" $(SHORTEN); \
	fi

reports/targets: reports/prep
	@if ! [ -n "$(REPORT_PATH)" -a -s "$(REPORT_PATH)" ]; then \
		exit 0; \
	fi; \
	if type -t dot >&/dev/null; then \
		OUT="$(REPORTDIR)/$(@F).png"; \
		report-targets < "$(REPORT_PATH)" \
		| dot -Tpng -o "$$OUT" \
		&& if [ -s "$$OUT" ]; then \
			echo "** target graph report: $$OUT"; \
		fi; \
	else \
		OUT="$(BUILDDIR)/targets.dot"; \
		report-targets < "$(REPORT_PATH)" > "$$OUT" \
		&& if [ -s "$$OUT" ]; then \
			echo "** graphviz missing, " \
				"target graph dot file: $$OUT"; \
		fi; \
	fi $(SHORTEN); \
	mv "$(REPORT_PATH)" "$(REPORTDIR)/$(@F).log"

else
all:; @:
endif
