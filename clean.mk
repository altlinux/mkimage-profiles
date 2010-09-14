clean:
	@echo '** cleaning up...'
	@find -name '*~' -delete >&/dev/null
	@[ -d build/ ] && \
		$(MAKE) -C build/ $@ GLOBAL_BUILDDIR=$(shell readlink build) \
	||:

distclean: clean
	@[ -d build/ ] && \
		rm -rf build/.git; \
		$(MAKE) -C build/ $@ GLOBAL_BUILDDIR=$(shell readlink build) && \
		rm -r $(shell readlink build) && \
		rm build \
	||:
