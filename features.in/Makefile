# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

ifndef BUILDDIR
help all:
	@echo "** BUILDDIR not defined; available features:"
	@for dir in */; do \
		echo -n "$$dir: "; \
		grep -h '^use/' $$dir/config.mk \
		| cut -f1 -d: \
		| tr '\n' ' ' \
		| sort -u; \
	done
else

include $(BUILDDIR)/distcfg.mk

# first rsync what's static, and make backups (*~) --
# these might signal of file clashes (or plain dirt);
# second, care for toplevel and tagged script dirs;
# then handle two more ways of implementing a feature
#
# NB: some subprofiles will be specified as "src/dst"
#     -- then both src/ and dst/ can hold the addons;
#     still both pieces go into a single destination

### {image-,}scripts.d/ get rsynced twice :-/
### still we don't want the trimmed-down case

### sorry for somewhat complicated and overly long lines
all:
	@echo "** starting feature configuration"
	@if [ -n "$(GLOBAL_DEBUG)" ]; then \
		echo "** target subprofiles: $(SUBPROFILES)"; \
		echo "** requested features: $(FEATURES)"; \
	fi
	@for feat in $(FEATURES); do \
		pushd "$$feat" && \
		for sub in / $(SUBPROFILES); do \
			src="$${sub%/*}"; \
			dst="$${sub#*/}"; \
			if [ -d "$$src" ]; then rsync -qab "$$src/" "$(BUILDDIR)/$$dst/"; fi; \
			if [ -d "$$dst" ]; then rsync -qab "$$dst/" "$(BUILDDIR)/$$dst/"; fi; \
			for dir in lib {image-,}scripts.d; do \
				destdir="$(BUILDDIR)/$$dst/$$dir/"; \
				if [ -d "$$destdir" ]; then \
					if [ -d "$$dir" ]; then \
						rsync -qab "$$dir/" "$$destdir/"; \
					fi; \
					if [ -d "tagged/$$dir" ]; then \
						if pushd "tagged/$$dir"; then \
							echo "$$feat && ($$src || $$dst)" \
							| tags2lists . \
							| xargs -r cp -v -pLt "$$destdir" --; \
							popd; \
						fi; \
					fi; \
				fi; \
			done; \
			if type -t git >&/dev/null && \
			   pushd "$(BUILDDIR)/$$dst/"; then \
				test -n "`git status -s`" && \
				git add . && \
				if [ -n "$$dst" ]; then \
					the="$$sub subprofile"; \
				else \
					the="toplevel"; \
				fi && \
				git commit -qam "$$feat feature ($$the part)"; \
				popd; \
			fi; \
		done; \
		if [ -x "generate.sh" ]; then sh generate.sh; fi; \
		if [ -s "generate.mk" ]; then $(MAKE) -f generate.mk; fi; \
		if type -t git >&/dev/null && \
		   pushd "$(BUILDDIR)/"; then \
			if test -n "`git status -s`"; then \
				git add . && \
				git commit -qam "$$feat feature generation complete"; \
			fi; \
			popd; \
		fi; \
		popd; \
	done
	@find "$(BUILDDIR)/" -name '*~' \
	| sed "s,$(BUILDDIR)/,** warning: file clash: ," >&2
endif
