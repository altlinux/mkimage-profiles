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
else
SHORTEN := >>$(BUILDLOG)
endif

report = $(and $(1),$(report_body))
define report_body
{ if [ -s "$$OUT" ]; then \
	echo "** $(1): $$OUT" $(SHORTEN); \
fi; }
endef

all: reports/targets reports/scripts reports/cleanlog reports/contents
	@if [ -n "$(IMAGE_OUTPATH)" ]; then \
		cp -a "$(REPORTDIR)" "$(LOGDIR)/$(IMAGE_OUTFILE).reports"; \
	fi

reports/prep:
	@mkdir -p "$(REPORTDIR)"

# try to drop common noise rendering diff(1) mostly useless
reports/cleanlog: reports/prep
	@OUT="$(REPORTDIR)/$(@F).log"; \
	BUILDDIR="$(BUILDDIR)" \
	cleanlog < $(BUILDLOG) > "$$OUT" \
	&& $(call report,diffable log)

reports/scripts: reports/prep
	@OUT="$(REPORTDIR)/$(@F).log"; \
	grep "^mki.*scripts: Run: " $(BUILDLOG) \
	| sed -rn "s,^.*($(BUILDDIR)|$(SYMLINK))/(.*)'$$,\2,p" > "$$OUT" \
	&& $(call report,scripts report)

reports/targets: reports/prep
	@if ! [ -n "$(REPORT_PATH)" -a -s "$(REPORT_PATH)" ]; then \
		exit 0; \
	fi; \
	if type -t dot >&/dev/null; then \
		OUT="$(REPORTDIR)/$(@F).png"; \
		report-targets < "$(REPORT_PATH)" \
		| dot -Tpng -o "$$OUT" \
		&& $(call report,target graph report); \
	else \
		OUT="$(BUILDDIR)/targets.dot"; \
		report-targets < "$(REPORT_PATH)" > "$$OUT" \
		&& $(call report,graphviz missing, target graph dot file); \
	fi; \
	mv "$(REPORT_PATH)" "$(REPORTDIR)/$(@F).log"

reports/contents: reports/prep
	@case $(IMAGE_OUTFILE) in \
	*.iso) \
		if type -t isoinfo >&/dev/null; then \
			OUT="$(REPORTDIR)/$(@F).txt"; \
			isoinfo -f -R -i $(IMAGE_OUTPATH) > $$OUT \
			&& $(call report,contents list); \
		else \
			echo "reports.mk: missing isoinfo" >&2; \
		fi; \
	esac

else
all:; @:
endif
