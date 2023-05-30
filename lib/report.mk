# enable make target tracing

ifeq (,$(CHECK))
ifneq (,$(DEBUG))
ifneq (,$(REPORT))
TRACE_PREFIX := trace:building
OLD_SHELL := $(SHELL)
SHELL = $(info $(TRACE_PREFIX) $@$(if $^$|, -> $^ $|))$(OLD_SHELL)
# piggyback BUILDDIR back into supervising environment
$(info $(TRACE_PREFIX) BUILDDIR = $(BUILDDIR))
endif
endif
endif
