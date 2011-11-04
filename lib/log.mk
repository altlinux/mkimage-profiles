# simple logging switch inspired by netch@'s advice:
# you can add plain $(LOG) to a rule recipe line to moderate it
# (logfile is automatically truncated during profile/init)

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

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

# in build.mk, naive TIME gets expanded a bit too early (no need to export btw)
DATE = $(shell date +%Y%m%d)
TIME = `date +%H:%M:%S`

export BUILDLOG DATE GLOBAL_DEBUG GLOBAL_VERBOSE LOG MAKE SHELL
