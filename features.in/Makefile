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

### sorry for somewhat complicated and overly long lines
all:
	@echo "** starting feature configuration"
	@if [ -n "$(GLOBAL_DEBUG)" ]; then \
		echo "** target subprofiles: $(SUBPROFILES)"; \
		echo "** requested features: $(FEATURES)"; \
	fi
	@for feat in $(FEATURES); do \
		if [ -n "$(GLOBAL_DEBUG)" ]; then \
			echo "** adding $$feat feature"; \
		fi; \
		pushd "$$feat" >/dev/null && \
		for sub in / $(SUBPROFILES); do \
			dirtags=; \
			if [ "$$sub" = / ]; then \
				parts=lib; \
				srcdirs="."; \
				dst="."; \
			else \
				parts=; \
				src="$${sub%/*}"; \
				dst="$${sub#*/}"; \
				srcdirs=; \
				if [ -d "$$src" ]; then \
					srcdirs="$$src"; \
					dirtags="&& $$src"; \
				fi; \
				if [ -d "$$dst" -a "$$dst" != "$$src" ]; then \
					srcdirs="$$srcdirs $$dst"; \
					dirtags="&& ($$src || $$dst)"; \
				fi; \
				for srcdir in $$srcdirs; do \
					rsync -qab --exclude tagged \
						"$$srcdir/" "$(BUILDDIR)/$$dst/"; \
				done; \
			fi; \
			if [ -n "$(GLOBAL_DEBUG)" ]; then \
				echo "** src=[$$src] dst=[$$dst] srcdirs=[$$srcdirs]"; \
			fi; \
			for srcdir in $$srcdirs; do \
				[ -d "$$srcdir" ] || continue; \
				pushd "$$srcdir" >&/dev/null; \
				for part in $$parts {image-,}scripts.d; do \
					destdir="$(BUILDDIR)/$$dst/$$part"; \
					[ -d "$$destdir" ] || continue; \
					if [ "$$sub" = / -a -d "$$part" ]; then \
						rsync -qab "$$part/" "$$destdir/"; \
					fi; \
					[ -d "tagged/$$part" ] || continue; \
					[ "$$srcdir" != "." ] || continue; \
					pushd "tagged/$$part" >/dev/null; \
					echo "$$feat $$dirtags" \
					| tags2lists . \
					| xargs -r cp -vpLt "$$destdir" --; \
					popd >/dev/null; \
				done; \
				popd >&/dev/null; \
			done; \
			if type -t git >&/dev/null && \
			   pushd "$(BUILDDIR)/$$dst/" >/dev/null; then \
				test -n "`git status -s`" && \
				git add . && \
				if [ -n "$$dst" ]; then \
					the="$$sub subprofile"; \
				else \
					the="toplevel"; \
				fi && \
				git commit -qam "$$feat feature: $$the part added"; \
				popd >/dev/null; \
			fi; \
		done; \
		if [ -x "generate.sh" ]; then sh generate.sh; fi; \
		if [ -s "generate.mk" ]; then $(MAKE) -f generate.mk; fi; \
		if type -t git >&/dev/null && \
		   pushd "$(BUILDDIR)/" >/dev/null; then \
			if test -n "`git status -s`"; then \
				git add . && \
				git commit -qam "$$feat feature generation complete"; \
			fi; \
			popd >/dev/null; \
		fi; \
		popd >/dev/null; \
	done
	@find "$(BUILDDIR)/" -name '*~' \
	| sed "s,$(BUILDDIR)/,** warning: file clash: ," >&2
endif
