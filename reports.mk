# collect what's left

ifneq (,$(REPORT))

include lib/common.mk

BUILDDIR := $(shell sed -n 's/^.* BUILDDIR = \(.*\)/\1/p' "$(REPORT_PATH)")
BUILDLOG := $(BUILDDIR)/$(BUILD_LOG)
BUILDCFG := $(BUILDDIR)/distcfg.mk
REPORTDIR := $(BUILDDIR)/reports
IMAGE_OUTPATH := $(shell sed -n 's/^IMAGE_OUTPATH = \(.*\)/\1/p' $(BUILDLOG))
IMAGE_OUTFILE := $(shell sed -n 's/^IMAGE_OUTFILE = \(.*\)/\1/p' $(BUILDLOG))
LOGDIR := $(shell sed -n 's/^LOGDIR = \(.*\)/\1/p' $(BUILDLOG))
ifeq (,$(LOGDIR))
LOGDIR := $(shell sed -n 's/^LOGDIR ?= \(.*\)/\1/p' $(BUILDCFG))
endif
ifeq (,$(IMAGE_OUTPATH))
TARGET_NAME := $(shell sed -n 's/^IMAGE_NAME = \(.*\)/\1/p' $(BUILDDIR)/distcfg.mk)
TARGET_TYPE := $(shell sed -n 's/^IMAGE_TYPE = \(.*\)/\1/p' $(BUILDDIR)/distcfg.mk)
TARGET_NAME := $(TARGET_NAME).$(TARGET_TYPE)
LOGDIR := $(LOGDIR)/CHECK
endif

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

ifneq (,$(IMAGE_OUTPATH))
all: reports/targets reports/scripts reports/cleanlog \
	reports/contents reports/packages
	@rm -fr "$(LOGDIR)/$(IMAGE_OUTFILE).reports"
	@cp -a "$(REPORTDIR)" "$(LOGDIR)/$(IMAGE_OUTFILE).reports"
	@mv $(LOGDIR)/{$(IMAGE_OUTFILE),$(IMAGE_OUTFILE).reports/build}.log
	@mv $(LOGDIR)/{$(IMAGE_OUTFILE),$(IMAGE_OUTFILE).reports/build}.cfg
	@find $(BUILDDIR)/pkg/ -type f | sed 's:$(BUILDDIR)/pkg/::' > \
		"$(LOGDIR)/$(IMAGE_OUTFILE).reports/pkg.list"
else
all: reports/prep reports/targets reports/scripts
	@rm -fr "$(LOGDIR)/$(TARGET_NAME).reports"
	@cp -a "$(REPORTDIR)" "$(LOGDIR)/$(TARGET_NAME).reports"
	@if [ -f "$(BUILDCFG)" ]; then \
		cp -a "$(BUILDCFG)" "$(LOGDIR)/$(TARGET_NAME).reports/build.cfg"; \
	fi
	@find $(BUILDDIR)/pkg/ -type f | sed 's:$(BUILDDIR)/pkg/::' > \
		"$(LOGDIR)/$(TARGET_NAME).reports/pkg.list"	 
endif

reports/prep:
	@mkdir -p "$(REPORTDIR)" "$(LOGDIR)"

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
		OUT="$(REPORTDIR)/$(@F).svgz"; \
		report-targets < "$(REPORT_PATH)" \
		| dot -Tsvgz -o "$$OUT" \
		&& $(call report,target graph report); \
		if type -t rsvg-convert >&/dev/null; then \
			IN="$$OUT"; \
			OUT="$(REPORTDIR)/$(@F).pdf"; \
			rsvg-convert -f pdf "$$IN" -o "$$OUT"; \
		fi; \
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

reports/packages: SHELL = /bin/bash
reports/packages: reports/prep
	@grep -E 'chroot/.in/[^/]*.rpm' < $(BUILDLOG) | \
		cut -d' ' -f 1 | tr -d "'"'`' | \
		tee /dev/stderr 2> >(sed 's,^.*/,,' | \
			sort -u > "$(REPORTDIR)/list-rpms.txt") | \
		xargs -r rpm -qp --queryformat '%{sourcerpm}\n' | \
		sort -u > "$(REPORTDIR)/list-srpms.txt"

else
all:; @:
endif
