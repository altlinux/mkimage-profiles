# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk

# first rsync what's static, and make backups (*~) --
# these might signal of file clashes (or plain dirt);
# then handle two more ways of implementing a feature
# NB: some subprofiles will be specified as src/dest
all:
	@echo "** starting feature configuration"
	@if test -n "$(GLOBAL_DEBUG)"; then \
		echo "** target subprofiles: $(notdir $(SUBPROFILES))"; \
		echo "** requested features: $(FEATURES)"; \
	fi
	@for dir in $(FEATURES); do \
		for sub in $(SUBPROFILES); do \
			dst="$${sub#*/}" && \
			if test -d "$$dir/$$dst/"; then \
				if rsync -qab "$$dir/$$dst/" \
					"$(BUILDDIR)/$$dst/"; \
				then \
					type -t git >&/dev/null && \
					pushd "$(BUILDDIR)/$$dst/" && \
					git add . && \
					git commit -qam "$$dir feature ($$dst subprofile part)" ||:; \
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
		type -t git >&/dev/null && \
		pushd "$(BUILDDIR)/" && \
		git add . && \
		git commit -qam "$$dir feature generation complete" ||:; \
		popd; \
	done
	@find "$(BUILDDIR)/" -name '*~' \
	| sed "s,$(BUILDDIR)/,** warning: file clash: ," >&2

# FIXME: drop or fix regarding undefined BUILDDIR being ok
#help:
#	@echo "** available features:"
#	@grep -h '^use/' */config.mk | fmt -sw"$$((COLUMNS>>1))" | column -t
