# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

ifndef BUILDDIR

help/plus all: banner
	@$(call grepper,'^+')

help/features: banner
	@$(call grepper,'^use/')

banner:
	@echo "** BUILDDIR not defined; available features:"

grepper = $(and $(1),$(grepper_body))
define grepper_body
	@for dir in */; do \
		out="`grep -h $(1) $$dir/config.mk \
		| cut -f1 -d: \
		| tr ' 	' '\n\n' \
		| grep $(1) \
		| tr '\n' ' ' \
		| sort -u`"; \
		[ -z "$$out" ] || echo "$$dir: $$out"; \
	done
endef

check:
	@../bin/check-recipe */config.mk

%:
	$(error BUILDDIR not defined)

else

export BUILDDIR

include $(BUILDDIR)/distcfg.mk

# first rsync what's static, and make backups (*~) --
# these might signal of file clashes (or plain dirt);
# second, care for toplevel dirs;
# then handle feature generator scripts
#
# NB: some subprofiles will be specified as "src/dst"
#     -- then both src/ and dst/ can hold the addons;
#     still both pieces go into a single destination

### sorry for somewhat complicated and overly long lines

TARGETS := prep $(FEATURES) finalize

.PHONY: $(TARGETS)
all:  | $(TARGETS)

prep:
	@echo "** starting feature configuration"
	@if [ -n "$(GLOBAL_DEBUG)" ]; then \
		echo "** target subprofiles: $(SUBPROFILES)"; \
		echo "** requested features: $(FEATURES)"; \
	fi

# feat
# NB: this is somewhat complicated since it has to handle "$sub" like:
#     - "/": copy feature's toplevel parts to the BUILDDIR toplevel
#     - "stage1": copy feature's stage1 parts into stage1 subprofile
#     - "stage2@live": copy feature's stage2 parts into live subprofile
#     - "rootfs@/": copy feature's rootfs parts into BUILDDIR toplevel
$(FEATURES):
	@feat=$@; \
	args="-qab --exclude README --exclude config.mk"; \
	args="$$args --exclude generate.mk --exclude generate.sh"; \
	if [ -n "$(GLOBAL_DEBUG)" ]; then \
		echo "** adding $$feat feature"; \
	fi; \
	pushd "$$feat" >/dev/null && \
	for sub in / $(SUBPROFILES); do \
		if [ "$$sub" = / ]; then \
			srcdirs="."; \
			dst="."; \
		else \
			src="$${sub%@*}"; \
			dst="$${sub#*@}"; \
			if [ "$$src" = / ]; then \
				echo "** src=/: you don't want this" >&2; \
				exit 1; \
			fi; \
			if [ "$$dst" = / -o "$$dst" = "" ]; then \
				dst="."; \
			fi; \
			srcdirs=; \
			if [ -d "$$src" ]; then \
				srcdirs="$$src"; \
			fi; \
			if [ -d "$$dst" -a "$$dst" != "$$src" ]; then \
				srcdirs="$${srcdirs:+$$srcdirs }$$dst"; \
			fi; \
			: "why this overduplication was done? (still needed)"; \
			for srcdir in $$srcdirs; do \
				rsync $$args "$$srcdir/" "$(BUILDDIR)/$$dst/"; \
			done; \
		fi; \
		if [ -n "$(GLOBAL_DEBUG)" ]; then \
			echo "** src=[$$src] dst=[$$dst] srcdirs=[$$srcdirs]"; \
		fi; \
		for srcdir in $$srcdirs; do \
			[ -d "$$srcdir" ] || continue; \
			pushd "$$srcdir" >&/dev/null; \
			for part in lib {image-,}scripts.d; do \
				destdir="$(BUILDDIR)/$$dst/$$part"; \
				[ -d "$$destdir" ] || continue; \
				if [ "$$sub" = / -a -d "$$part" ]; then \
					rsync $$args "$$part/" "$$destdir/"; \
				fi; \
			done; \
			popd >&/dev/null; \
		done; \
		if [ -n "$$dst" -a "$$dst" != "." ]; then \
			the="$$sub subprofile"; \
		else \
			the="toplevel"; \
		fi; \
		mp-commit "$(BUILDDIR)/$$dst/" "$$feat feature: $$the part added"; \
	done; \
	if [ -x "generate.sh" ]; then sh generate.sh; fi; \
	if [ -s "generate.mk" ]; then $(MAKE) -f generate.mk; fi; \
	mp-commit "$(BUILDDIR)" "$$feat feature generation complete"; \
	popd >/dev/null

finalize:
	@find "$(BUILDDIR)/" -name '*~' \
	| sed "s,$(BUILDDIR)/,** warning: file clash: ," >&2

endif
