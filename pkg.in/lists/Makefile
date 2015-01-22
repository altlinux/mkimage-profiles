# step 3: copy package lists referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR

pkgdups:
	@find -type f ! -name README ! -name Makefile \
	| grep -v '~$$' \
	| sed 's,^\./,,g' \
	| xargs ../../bin/pkgdups

%:
	$(error BUILDDIR not defined)

else

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/lists
TARGET := $(BUILDDIR)/$(SUFFIX)

all: | $(TARGET) $(GLOBAL_DEBUG) $(DOTBASE) copy-lists copy-groups grep-archdep
	@mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"

# env | sort -u | grep _LISTS | xargs -r cp -t
copy-lists:
	@echo $(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),$($V))) \
	| xargs -r -- cp --parents -at $(TARGET) --

copy-groups:
	@if [ -n "$(THE_GROUPS)$(MAIN_GROUPS)" ]; then \
		cp -at $(TARGET) -- $(THE_GROUPS) $(MAIN_GROUPS); \
	fi

grep-archdep: a = $(ARCH)
grep-archdep: s = [:space:]
grep-archdep:
	# xargs -L 1024 -n 1024 ? -- breaks -I
	@find $(TARGET) -type f \
	| xargs -I '__' sh -c '\
		sed -rni "s/\\<([^@ ]*)\\>|\\<([^@ ]*)@$a\\>/\\1\\2/pg" __; \
		sed -i -r "s/\\<([^@ ]*)@[^@ ]+\\> *//g" __'

# do beforehand as foreach gets expanded before recipe execution
$(TARGET):
	@mkdir -p $(TARGET)

# figure out *_LISTS variables and print them out nicely
debug:
	@echo -e $(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell echo '\\n"**"' $V: $($V)))) '\n'

endif
