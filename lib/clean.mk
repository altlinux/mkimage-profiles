# this makefile can be used standalone

# drop stock predefined rules
.DEFAULT:

SYMLINK = build

# tmpfs-sparing extra rule: cleanup workdir after completing each stage
# (as packed results are saved this only lowers RAM pressure)
# NB: it's useful enough to be enabled by default in DEBUG abscence
ifndef DEBUG
CLEAN ?= 1
endif
ifdef CLEAN
export GLOBAL_CLEAN_WORKDIR = clean-current
ifdef DEBUG
WARNING = (NB: DEBUG scope is limited when CLEAN is enabled)
endif
endif

# ordinary clean: destroys workdirs but not the corresponding results
# NB: our output MUST go into stderr to escape POSTPROC
clean:
	@{ \
	find -name '*~' -delete >&/dev/null ||:; \
	if [ -L "$(SYMLINK)" -a -d "$(SYMLINK)"/ ]; then \
		if [ -z "$(QUIET)" ]; then \
			echo "$(TIME) cleaning up $(WARNING)"; \
		fi; \
		$(MAKE) -C "$(SYMLINK)" $@ \
			GLOBAL_BUILDDIR="$(realpath $(SYMLINK))" $(LOG) ||:; \
	fi; \
	} >&2

# there can be some sense in writing log here even if normally
# $(BUILDDIR)/ gets purged: make might have failed,
# and BUILDLOG can be specified by hand either
distclean: clean
	@{ \
	if [ -L "$(SYMLINK)" -a -d "$(SYMLINK)"/ ]; then \
		build="$(realpath $(SYMLINK)/)"; \
		if [ "$$build" = / ]; then \
			echo "** ERROR: invalid \`"$(SYMLINK)"' symlink" >&2; \
			exit 128; \
		else \
			$(MAKE) -C "$(SYMLINK)" $@ \
				GLOBAL_BUILDDIR="$$build" $(LOG) ||: \
			rm -rf "$$build"; \
		fi; \
	fi; \
	rm -f "$(SYMLINK)"; \
	} >&2

# builddir existing outside read-only metaprofile is less ephemeral
# than BUILDDIR variable is -- usually it's unneeded afterwards
postclean: build-image
	@{ \
	if [ "$(CLEAN)" != 0 ] && \
	   [ "0$(DEBUG)" -lt 2 ] && \
	   [ -z "$(CHECK)" ] && \
	   [ -z "$(REPORT)" ] && \
	   [ "$(NUM_TARGETS)" -gt 1 \
	       -o ! -t 1 \
	       -o ! -L "$(SYMLINK)" ]; \
	then \
		if [ -z "$(QUIET)" ]; then \
			echo "$(TIME) cleaning up after build"; \
		fi; \
		$(MAKE) -C "$(BUILDDIR)" distclean \
			GLOBAL_BUILDDIR="$(BUILDDIR)" $(LOG) ||:; \
		rm -rf "$(BUILDDIR)"; \
	fi; \
	} >&2
