+pipewire: use/sound/pipewire; @:
+pulse: use/sound/pulse; @:
+alsa:  use/sound/alsa; @:

# "bare" ALSA (which is good enough for many of us) with persistent levels
use/sound:
	@$(call add_feature)
	@$(call add,THE_LISTS,sound/base)
	@$(call add,THE_LISTS,$$(THE_SOUND))

# ALSA only sound (additional utils needed if using pulseaudio)
use/sound/alsa: use/sound
	@$(call set,THE_SOUND,sound/alsa)

# PulseAudio (useful for per-app levels, dynamic devices and networked sound)
use/sound/pulse: use/sound
	@$(call set,THE_SOUND,sound/pulseaudio)

use/sound/pipewire-services: use/services
	@$(call add,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE,pipewire.socket pipewire-pulse.socket)
	@$(call add,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE,wireplumber.service)

use/sound/pipewire: use/sound use/sound/pipewire-services
	@$(call set,THE_SOUND,sound/pipewire)
