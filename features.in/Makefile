# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk

# first rsync what's static, and make backups (*~) --
# these might signal of file clashes (or plain dirt);
# then handle two more ways of implementing a feature
# NB: some subprofiles will be specified as "src/dst"
#     (then both src/ and dst/ can hold the addons)
all:
	@echo "** starting feature configuration"
	@if [ -n "$(GLOBAL_DEBUG)" ]; then \
		echo "** target subprofiles: $(SUBPROFILES)"; \
		echo "** requested features: $(FEATURES)"; \
	fi
	@for dir in $(FEATURES); do \
		pushd "$$dir" && \
		for sub in $(SUBPROFILES); do \
			src="$${sub%/*}/"; \
			dst="$${sub#*/}/"; \
			if [ -d "$$src/" ]; then rsync -qab "$$src" "$(BUILDDIR)/$$dst/"; fi; \
			if [ -d "$$dst/" ]; then rsync -qab "$$dst" "$(BUILDDIR)/$$dst/"; fi; \
			type -t git >&/dev/null && \
			pushd "$(BUILDDIR)/$$dst/" && \
			git add . && \
			git commit -qam "$$dir feature ($$sub subprofile part)" ||:; \
			popd; \
		done; \
		for scripts in scripts.d image-scripts.d; do \
			if [ -d "$(BUILDDIR)/$$scripts" -a -d "$$scripts" ]; then \
				if rsync -qab "$$scripts/" "$(BUILDDIR)/$$scripts/"; then \
					type -t git >&/dev/null && \
					pushd "$(BUILDDIR)/$$scripts/" && \
					git add . && \
					git commit -qam "$$dir feature (toplevel $$scripts)" ||:; \
					popd; \
				fi; \
			fi; \
		done; \
		if [ -x "generate.sh" ]; then sh generate.sh; fi; \
		if [ -s "generate.mk" ]; then $(MAKE) -f generate.mk; fi; \
		type -t git >&/dev/null && \
		pushd "$(BUILDDIR)/" && \
		git add . && \
		git commit -qam "$$dir feature generation complete" ||:; \
		popd; \
		popd; \
	done
	@find "$(BUILDDIR)/" -name '*~' \
	| sed "s,$(BUILDDIR)/,** warning: file clash: ," >&2

# FIXME: drop or fix regarding undefined BUILDDIR being ok
#help:
#	@echo "** available features:"
#	@grep -h '^use/' */config.mk | fmt -sw"$$((COLUMNS>>1))" | column -t
