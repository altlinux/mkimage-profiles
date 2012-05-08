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

all: $(TARGET) $(GLOBAL_DEBUG) $(DOTBASE) copy-lists copy-groups
	@if type -t git >&/dev/null && cd $(TARGET); then \
		if [ -n "`git status -s`" ]; then \
			git add . && \
			git commit -qam "requested $(SUFFIX) copied over"; \
		fi; \
		cd - >&/dev/null; \
	fi

copy-lists:
	@# env | sort -u | grep _LISTS | xargs cp
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp --parents -at $(TARGET) \
				-- $(value $V))))

copy-groups:
	@if [ -n "$(THE_GROUPS)$(MAIN_GROUPS)" ]; then \
		cp -at $(TARGET) -- $(THE_GROUPS) $(MAIN_GROUPS); \
	fi

# do beforehand as foreach gets expanded before recipe execution
$(TARGET):
	@mkdir -p $(TARGET)

# figure out *_LISTS variables and print them out nicely
debug:
	@echo -e $(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell echo '\\n"**"' $V: $(value $V)))) '\n'

endif
