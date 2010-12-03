# step 3: copy package lists referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

include $(BUILDDIR)/.config.mk
TARGET := $(BUILDDIR)/pkg/lists/

# env | sort -u | grep _LISTS | xargs cp
all: prep debug
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp --parents -at $(TARGET) \
				-- $(value $V))))
	@cp -a .base $(GROUPS) $(TARGET)

# moving this into 'all' spoils execution order (clobbers results)
prep:
	@mkdir -p $(BUILDDIR)/pkg/lists

# dump *_LISTS variables' values
# TODO: consider GLOBAL_VERBOSE? (currently not coming with .config.mk)
#       (for cp -v then, too)
debug:
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(warning $V=$(value $V))))
	@echo "** LISTS: -- see above"
	@echo "** GROUPS: $(GROUPS)"
