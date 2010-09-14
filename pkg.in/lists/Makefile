# copy package lists referenced in distro configuration
# over to build dir

include $(BUILDDIR)/.config.mk

# env | sort -u | grep _LISTS | xargs cp
all: prep debug
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp --parents -at $(BUILDDIR)/pkg/lists/ \
				-- $(value $V))))
	@cp -a .base $(BUILDDIR)/pkg/lists/

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
