clean:
	@echo '** cleaning up...'
	@[ -d build/ ] && \
		make -C build $@ GLOBAL_BUILDDIR=$(shell readlink build) \
	||:

distclean: clean
	@[ -d build/ ] && \
		make -C build $@ GLOBAL_BUILDDIR=$(shell readlink build) && \
		rm -r $(shell readlink build) && \
		rm .config.mk build \
	||:

# it can be symlinked if r/w (see configure);
# if not, then should come from environment
#BUILDDIR ?= $(shell realpath build)
BUILDDIR ?= $(shell realpath build)

prep:
	@echo BUILDDIR: $(BUILDDIR)
