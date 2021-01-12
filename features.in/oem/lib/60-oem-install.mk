all: $(GLOBAL_DEBUG) $(OEM_INSTALL:%=oem-install)

oem-install:
	@cd pkg && tar -cf ../files/.install3.tar *
