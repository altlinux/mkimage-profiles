clean:
	@echo '** cleaning up...'
	@[ -d build/ ] && \
		make -C build/ $@ GLOBAL_BUILDDIR=$(shell readlink build) \
	||:

distclean: clean
	@[ -d build/ ] && \
		make -C build/ $@ GLOBAL_BUILDDIR=$(shell readlink build) && \
		rm -r $(shell readlink build) && \
		rm build \
	||:
