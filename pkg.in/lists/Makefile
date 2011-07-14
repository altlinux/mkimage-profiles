# step 3: copy package lists referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/lists
TARGET := $(BUILDDIR)/$(SUFFIX)

all: $(TARGET) $(GLOBAL_DEBUG)
	# env | sort -u | grep _LISTS | xargs cp
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp --parents -at $(TARGET) \
				-- $(value $V))))
	# construct .base packagelist for alterator-pkg
	@( \
		echo "### generated via pkg.in/lists/Makefile" && \
		echo "### BASE_LISTS" && \
		cat $(BASE_LISTS) /dev/null && \
		echo "### branding" && \
		echo "branding-$(BRANDING)-release" && \
		echo "### COMMON_PACKAGES" && \
		echo "$(COMMON_PACKAGES)" && \
		echo "### BASE_PACKAGES" && \
		echo "$(BASE_PACKAGES)" \
	) | sed -re '/^[^[:space:]#]/ s/[[:space:]]+/\n/g' >$(TARGET)/.base
	@[ -z $(GROUPS) ] || cp -at $(TARGET) $(GROUPS)
	@type -t git >&/dev/null && \
	cd $(TARGET) && \
	git add . && \
	git commit -qam "$(SUFFIX)";

# do beforehand as foreach gets expanded before recipe execution
$(TARGET):
	@mkdir -p $(TARGET)

debug:
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(warning $V=$(value $V))))
	@echo "** LISTS: -- see above"
	@echo "** GROUPS: $(GROUPS)"
