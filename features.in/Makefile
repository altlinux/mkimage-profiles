ifdef BUILDDIR

# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

-include $(BUILDDIR)/distcfg.mk

# first rsync what's static, and make backups --
# these might signal of file clashes (or plain dirt);
# then handle two more ways of implementing a feature

all:
	@echo "** starting feature configuration"
	@if test -n "$(DEBUG)"; then echo "** requested: $(FEATURES)"; fi
	@for dir in $(FEATURES); do \
		for sub in $(SUBPROFILES); do \
			if test -d $$dir/$$sub/; then \
				if rsync -ab $$dir/$$sub/ $(BUILDDIR)/$$sub/; \
				then \
					type -t git >&/dev/null && \
					pushd $(BUILDDIR)/$$sub/ && \
					git add . && \
					git commit -qam "$@/$$dir/$$sub" ||:; \
					popd; \
				fi; \
			fi; \
		done; \
		if test -x $$dir/generate.sh; then \
			pushd $$dir && \
			sh generate.sh; \
			popd; \
		fi; \
		if test -s $$dir/generate.mk; then \
			$(MAKE) -C $$dir -f generate.mk; \
		fi; \
	done

help:
	@echo "** available features:"
	@grep -h '^use/' */config.mk

else
$(error BUILDDIR not defined)
endif
