# this makefile can be used standalone

# drop stock predefined rules
.DEFAULT:

# tmpfs-sparing extra rule: cleanup workdir after completing each stage
# (as packed results are saved this only lowers RAM pressure)
ifdef CLEAN
export GLOBAL_CLEAN_WORKDIR = clean-current
ifdef DEBUG
WARNING = (both CLEAN and DEBUG defined, debug options will be limited)
endif
endif

# ordinary clean: destroys workdirs but not the corresponding results
clean:
	@echo '** cleaning up $(WARNING)'
	@find -name '*~' -delete >&/dev/null ||:
	@if [ -L build -a -d build/ ]; then \
		$(MAKE) -C build $@ GLOBAL_BUILDDIR=$(shell readlink build) $(LOG) ||:; \
	fi

# there can be some sense in writing log here even if normally
# $(BUILDDIR)/ gets purged: make might have failed,
# and BUILDLOG can be specified by hand either
distclean: clean
	@if [ -L build -a -d build/ ]; then \
		rm -rf build/.git; \
		$(MAKE) -C build $@ GLOBAL_BUILDDIR=$(shell readlink build) $(LOG) || \
			rm -rf build/; \
		rm -rf $(shell readlink build); \
	fi
	@rm -f build ||:
