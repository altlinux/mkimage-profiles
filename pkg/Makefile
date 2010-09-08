# copy package lists referenced in distro configuration
# over to build dir

include $(BUILDDIR)/.config.mk
.PHONY: pkgs

# env | sort -u | grep _LISTS | xargs cp
pkgs: prep test
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(shell cp -a $(addprefix lists/,$(value $V)) \
				      $(BUILDDIR)/pkg/lists/)))
	@cp -a lists/.base $(BUILDDIR)/pkg/lists/

# moving this into pkgs spoils execution order (clobbers results)
prep:
	mkdir -p $(BUILDDIR)/pkg/{lists,groups}

# dump *_LISTS variables' values
# TODO: consider GLOBAL_VERBOSE? (currently not coming with .config.mk)
test:
	@$(foreach V, \
		$(filter %_LISTS,$(sort $(.VARIABLES))), \
		$(if $(filter environment% file,$(origin $V)),\
			$(warning $V=$(value $V))))
