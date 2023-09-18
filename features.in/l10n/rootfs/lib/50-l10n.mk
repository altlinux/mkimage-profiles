# supplement live with keyboard layout setup

XKB_KEYMAPS := $(subst $(SPACE),$(COMMA),$(XKB_KEYMAPS))

debug::
	@echo "** live: LOCALES: $(LOCALES)"
	@echo "** live: LOCALE: $(LOCALE)"
	@echo "** live: XKB_KEYMAPS: $(XKB_KEYMAPS)"
