# step 3: copy package groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR

check all: check-parents check-echo check-pkglists; @:

check-parents:
	@find -name "*.directory" \
	| xargs -r -- sed -rn 's,^X-Alterator-Parent=(.*)$$,\1,p' \
	| sort -u \
	| while read group; do \
		if ! [ -f "$$group.directory" ]; then \
			echo "** Error: missing parent group referenced in:"; \
			grep -rl "=$$group$$" $$(find -name "*.directory"); \
		fi >&2; \
	done

check-echo:
	@echo

check-pkglists:
	@find -name "*.directory" \
	| xargs -r -- sed -rn 's,^X-Alterator-PackageList=(.*)$$,\1,p' \
	| sort -u \
	| while read list; do \
		if ! [ -f "../lists/$$list" ]; then \
			echo "** Error: missing pkglist $$list referenced:"; \
			grep -rl "=$$list$$" $$(find -name "*.directory"); \
		fi >&2; \
	done

else

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/groups
TARGET := $(BUILDDIR)/$(SUFFIX)

all: $(GLOBAL_DEBUG)
	@if [ -n "$(THE_GROUPS)$(MAIN_GROUPS)" ]; then \
		mkdir -p $(TARGET) && \
		cp --parents -at $(TARGET) -- \
			$(addsuffix .directory,$(THE_GROUPS) $(MAIN_GROUPS)); \
		mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"; \
	fi

debug:
	@echo "** THE_GROUPS: $(THE_GROUPS)"
	@echo "** MAIN_GROUPS: $(MAIN_GROUPS)"

endif
