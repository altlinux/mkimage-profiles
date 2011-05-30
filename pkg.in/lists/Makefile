# step 3: copy package lists referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/lists
TARGET := $(BUILDDIR)/$(SUFFIX)

# env | sort -u | grep _LISTS | xargs cp
all: $(TARGET) debug
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp --parents -at $(TARGET) \
				-- $(value $V))))
	@cp -a .base $(GROUPS) $(TARGET)
	@type -t git >&/dev/null && \
	cd $(TARGET) && \
	git add . && \
	git commit -qam "$(SUFFIX)"; \
	cd - >&/dev/null; \

# do beforehand as foreach gets expanded before recipe execution
$(TARGET):
	@mkdir -p $(TARGET)

debug:
ifdef GLOBAL_VERBOSE
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(warning $V=$(value $V))))
	@echo "** LISTS: -- see above"
	@echo "** GROUPS: $(GROUPS)"
endif
