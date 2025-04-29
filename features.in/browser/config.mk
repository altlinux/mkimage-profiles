use/browser:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(THE_BROWSER))
	@$(call try,THE_BROWSER,elinks)	# X11-less fallback

# amend as neccessary; firefox is treated separately due to its flavours
BROWSERS_i586 = netsurf epiphany elinks links2
BROWSERS_x86_64 := $(BROWSERS_i586) chromium  chromium-gost falkon seamonkey
BROWSERS_aarch64 = chromium chromium-gost netsurf epiphany falkon elinks links2
BROWSERS_riscv64 = epiphany midori netsurf elinks
BROWSERS_loongarch64 = chromium chromium-gost epiphany midori netsurf elinks
BROWSERS_e2k = netsurf elinks links2
BROWSERS_e2kv4 := $(BROWSERS_e2k)
BROWSERS := $(BROWSERS_$(ARCH))

$(addprefix use/browser/,$(BROWSERS)): use/browser/%: use/browser
	@$(call set,THE_BROWSER,$*)

ifneq (,$(filter-out x86_64 aarch64 loongarch64,$(ARCH)))
use/browser/chromium use/browser/chromium-gost: \
	use/browser/firefox use/browser/firefox/esr; @:
endif

ifneq (,$(filter-out aarch64 x86_64,$(ARCH)))
use/browser/falkon: use/browser/firefox use/browser/firefox/esr; @:
endif

ifneq (,$(filter-out i586 x86_64,$(ARCH)))
use/browser/seamonkey: use/browser/firefox use/browser/firefox/esr; @:
endif

# support both firefox and firefox-esr
use/browser/firefox: use/browser
ifeq (,$(filter-out i586,$(ARCH)))
	@$(call set,FX_FLAVOUR,-esr)
endif
	@$(call set,THE_BROWSER,firefox$$(FX_FLAVOUR))

# the complete lack of dependencies is intentional
use/browser/firefox/esr: ; @:
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call set,FX_FLAVOUR,-esr)
endif
