# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

-include $(BUILDDIR)/distcfg.mk

# first rsync what's static, and make backups --
# these might signal of file clashes (or plain dirt);
# then handle two more ways of implementing a feature
# NB: subprofile can be specified as src/dest
all:
	@echo "** starting feature configuration"
	@if test -n "$(GLOBAL_DEBUG)"; then echo "** requested: $(FEATURES)"; fi
	@for dir in $(FEATURES); do \
		for sub in $(SUBPROFILES); do \
			dst="$${sub#*/}" && \
			if test -d "$$dir/$$dst/"; then \
				if rsync -ab "$$dir/$$dst/" "$(BUILDDIR)/$$dst/"; \
				then \
					type -t git >&/dev/null && \
					pushd "$(BUILDDIR)/$$dst/" && \
					git add . && \
					git commit -qam "$@/$$dir/$$dst" ||:; \
					popd; \
				fi; \
			fi; \
		done; \
		if test -x "$$dir/generate.sh"; then \
			pushd "$$dir" && \
			sh generate.sh; \
			popd; \
		fi; \
		if test -s "$$dir/generate.mk"; then \
			$(MAKE) -C "$$dir" -f generate.mk; \
		fi; \
	done

help:
	@echo "** available features:"
	@grep -h '^use/' */config.mk
