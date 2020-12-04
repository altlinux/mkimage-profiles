all: $(GLOBAL_DEBUG) $(OEM_INSTALL:%=oem-install)

oem-install:
	@git archive HEAD:pkg > files/.install3.tar
