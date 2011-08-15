# this makefile is designed to be included in toplevel one
ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

# simple logging switch inspired by netch@'s advice:
# you can add plain $(LOG) to a rule recipe line to moderate it
# (logfile is automatically truncated during profile/init)

BUILDLOG ?= $(BUILDDIR)/build.log

# LOG holds a postprocessor
ifdef DEBUG
# 1) makefile target; 2) also passed to script hooks
GLOBAL_DEBUG := debug
GLOBAL_VERBOSE ?= $(DEBUG)
ifeq (2,$(DEBUG))
SHELL += -x
endif
LOG = >>$(BUILDLOG) 2>&1
else
MAKE += -s
LOG = 2>>$(BUILDLOG) >/dev/null
endif

DATE = $(shell date +%Y%m%d)

export BUILDLOG DATE DEBUG GLOBAL_DEBUG GLOBAL_VERBOSE LOG MAKE SHELL
