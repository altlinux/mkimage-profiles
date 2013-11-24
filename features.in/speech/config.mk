use/speech: use/sound
	@$(call add_feature)
	@$(call add,THE_LISTS,speech/voiceman speech/$$(SPEECH_LANG))
	@$(call add,THE_LISTS,speech/emacspeak)
	@$(call add,DEFAULT_SERVICES_ENABLE,voiceman)
	@$(call xport,SPEECH_LANG)

use/speech/en use/speech/ru:  use/speech/%: use/speech
	@$(call set,SPEECH_LANG,$*)
