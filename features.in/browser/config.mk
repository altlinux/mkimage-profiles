use/browser:
	@$(call add_feature)
	@$(call add,THE_PACKAGES_REGEXP,$$(THE_BROWSER))
	@$(call try,THE_BROWSER,webclient)	# fallback

use/browser/firefox use/browser/seamonkey \
	use/browser/chromium use/browser/epiphany \
	use/browser/qupzilla use/browser/rekonq \
	use/browser/elinks use/browser/links2: \
	use/browser/%: use/browser
	@$(call set,THE_BROWSER,$*)

use/browser/konqueror: use/browser
	@$(call set,THE_BROWSER,kdebase-konqueror)

use/browser/konqueror4: use/browser
	@$(call set,THE_BROWSER,kde4base-konqueror)

use/browser/firefox/live: use/browser/firefox
	@$(call add,THE_BROWSER,livecd-firefox)

# scarey, and will have to be done otherwise when l10n feature is there
use/browser/firefox/i18n: use/browser/firefox
	@$(call add,THE_BROWSER,firefox-be firefox-kk firefox-ru firefox-uk)

# fx29+
use/browser/firefox/classic: use/browser/firefox
	@$(call add,THE_BROWSER,firefox-classic_theme_restorer.*)

use/browser/seamonkey/i18n: use/browser/seamonkey
	@$(call add,THE_BROWSER,seamonkey-ru)

# inherently insecure, NPAPI only
use/browser/plugin/flash: use/browser
	@$(call add,THE_PACKAGES,mozilla-plugin-adobe-flash)

use/browser/plugin/java: use/browser
	@$(call add,THE_PACKAGES,mozilla-plugin-java-1.6.0-sun)
