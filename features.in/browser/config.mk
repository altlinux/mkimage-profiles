use/browser:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(THE_BROWSER))
	@$(call try,THE_BROWSER,elinks)	# X11-less fallback

# support both firefox and firefox-esr
use/browser/firefox: use/browser
	@$(call set,THE_BROWSER,firefox$$(FX_FLAVOUR))

use/browser/seamonkey use/browser/palemoon \
	use/browser/chromium use/browser/epiphany \
	use/browser/qupzilla use/browser/rekonq \
	use/browser/elinks use/browser/links2: \
	use/browser/%: use/browser
	@$(call set,THE_BROWSER,$*)

use/browser/konqueror: use/browser
	@$(call set,THE_BROWSER,kdebase-konqueror)

use/browser/konqueror4: use/browser
	@$(call set,THE_BROWSER,kde4base-konqueror)

# the complete lack of dependencies is intentional
use/browser/firefox/esr: use/browser
	@$(call set,FX_FLAVOUR,-esr)

use/browser/firefox/h264: use/browser/firefox
	@$(call add,THE_BROWSER,gst-libav)
	@$(call add,THE_BROWSER,gst-plugins-base1.0 gst-plugins-good1.0)

use/browser/firefox/live: use/browser/firefox
	@$(call add,THE_BROWSER,livecd-firefox)

# scarey, and will have to be done otherwise when l10n feature is there
use/browser/firefox/i18n: use/browser/firefox
	@$(call add,THE_BROWSER,firefox$$(FX_FLAVOUR)-kk)
	@$(call add,THE_BROWSER,firefox$$(FX_FLAVOUR)-ru)
	@$(call add,THE_BROWSER,firefox$$(FX_FLAVOUR)-uk)

# fx29+
use/browser/firefox/classic: use/browser/firefox
	@$(call add,THE_BROWSER,firefox-classic_theme_restorer)

use/browser/seamonkey/i18n: use/browser/seamonkey
	@$(call add,THE_BROWSER,seamonkey-ru)

use/browser/palemoon/i18n: use/browser/palemoon
	@$(call add,THE_BROWSER,palemoon-ru)

# inherently insecure, NPAPI only
use/browser/plugin/flash: use/browser
	@$(call add,THE_PACKAGES,mozilla-plugin-adobe-flash)

use/browser/plugin/java: use/browser
	@$(call add,THE_PACKAGES,mozilla-plugin-java-1.8.0-openjdk)
