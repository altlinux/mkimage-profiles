# this makefile is designed to be included in toplevel one
ifdef BUILDDIR

# simple logging switch inspired by netch@'s advice:
# you can add plain $(LOG) to a rule recipe line to moderate it
# (logfile is automatically truncated during profile/init)

BUILDLOG ?= $(BUILDDIR)/build.log

ifdef DEBUG
GLOBAL_VERBOSE ?= $(DEBUG)
ifeq (2,$(DEBUG))
SHELL += -x
endif
LOG = >>$(BUILDLOG) 2>&1
else
MAKE += -s
LOG = 2>>$(BUILDLOG) >/dev/null
endif

export BUILDLOG DEBUG GLOBAL_VERBOSE LOG MAKE SHELL

endif
