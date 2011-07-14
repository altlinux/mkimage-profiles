# this makefile can be used standalone

# drop stock predefined rules
.DEFAULT:

clean:
	@echo '** cleaning up'
	@find -name '*~' -delete >&/dev/null
	@if [ -L build -a -d build/ ]; then \
		$(MAKE) -C build $@ GLOBAL_BUILDDIR=$(shell readlink build) $(LOG); \
	fi

# there can be some sense in writing log here even if normally
# $(BUILDDIR)/ gets purged: make might have failed,
# and BUILDLOG can be specified by hand either
distclean: clean
	@if [ -L build -a -d build/ ]; then \
		rm -rf build/.git; \
		$(MAKE) -C build $@ GLOBAL_BUILDDIR=$(shell readlink build) $(LOG) && \
		rm -r $(shell readlink build); \
	fi
	@rm -f build
