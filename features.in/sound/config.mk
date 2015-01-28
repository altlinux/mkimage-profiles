+pulse: use/sound/pulse; @:
+alsa:  use/sound/alsa; @:

# "bare" ALSA (which is good enough for many of us) with persistent levels
use/sound:
	@$(call add_feature)
	@$(call add,THE_KMODULES,alsa sound)
	@$(call add,THE_LISTS,sound/base)

# ALSA only sound (additional utils needed if using pulseaudio)
use/sound/alsa: use/sound
	@$(call add,THE_PACKAGES,apulse)

# PulseAudio (useful for per-app levels, dynamic devices and networked sound)
use/sound/pulse: use/sound
	@$(call add,THE_LISTS,sound/pulseaudio)
