use/browser:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(THE_BROWSER))
	@$(call try,THE_BROWSER,elinks)	# X11-less fallback

# amend as neccessary; firefox is treated separately due to its flavours
BROWSERS_i586 = chromium seamonkey netsurf epiphany falkon otter-browser \
		elinks links2
BROWSERS_x86_64 := $(BROWSERS_i586)
BROWSERS_ppc64el = netsurf epiphany falkon otter-browser elinks links2
BROWSERS_aarch64 = chromium netsurf epiphany falkon otter-browser elinks links2
BROWSERS_armh = netsurf epiphany falkon otter-browser elinks links2
BROWSERS_mipsel = chromium seamonkey netsurf epiphany falkon otter-browser \
		  elinks links2
BROWSERS_riscv64 = netsurf elinks
BROWSERS_e2k = netsurf elinks links2
BROWSERS_e2kv4 := $(BROWSERS_e2k)
BROWSERS := $(BROWSERS_$(ARCH))

$(addprefix use/browser/,$(BROWSERS)): use/browser/%: use/browser
	@$(call set,THE_BROWSER,$*)

ifneq (,$(filter-out x86_64 i586 aarch64 mipsel,$(ARCH)))
use/browser/chromium: use/browser/firefox use/browser/firefox/esr; @:
endif

ifeq (,$(filter-out e2k%,$(ARCH)))
use/browser/falkon: use/browser/firefox use/browser/firefox/esr; @:
endif

# support both firefox and firefox-esr
use/browser/firefox: use/browser
	@$(call set,THE_BROWSER,firefox$$(FX_FLAVOUR))

# the complete lack of dependencies is intentional
use/browser/firefox/esr:
	@$(call set,FX_FLAVOUR,-esr)

use/browser/firefox/live: use/browser/firefox
	@$(call add,THE_BROWSER,livecd-firefox)
