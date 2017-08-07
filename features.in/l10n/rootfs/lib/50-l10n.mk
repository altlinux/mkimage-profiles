# supplement live with keyboard layout setup

XKB_KEYMAPS := $(subst $(SPACE),$(COMMA),$(XKB_KEYMAPS))

# handle the layouts with a specific variant in the wild
XKB_VARIANTS := $(subst ru,winkeys, \
		$(subst ua,winkeys, \
		$(subst be,winkeys, \
		$(subst us,,$(XKB_KEYMAPS)))))

debug::
	@echo "** live: LOCALES: $(LOCALES)"
	@echo "** live: LOCALE: $(LOCALE)"
	@echo "** live: XKB_KEYMAPS: $(XKB_KEYMAPS)"
	@echo "** live: XKB_VARIANTS: $(XKB_VARIANTS)"
