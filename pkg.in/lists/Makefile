# copy package lists referenced in distro configuration
# over to build dir

include $(BUILDDIR)/.config.mk

# env | sort -u | grep _LISTS | xargs cp
all: prep test
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp --parents -avt $(BUILDDIR)/pkg/lists/ \
				-- $(value $V) >> $(BUILDDIR)/log 2>&1)))
	@cp -av .base $(BUILDDIR)/pkg/lists/

# moving this into 'all' spoils execution order (clobbers results)
prep:
	@mkdir -p $(BUILDDIR)/pkg/lists

# dump *_LISTS variables' values
# TODO: consider GLOBAL_VERBOSE? (currently not coming with .config.mk)
#       (for cp -v then, too)
test:
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(warning $V=$(value $V))))
