ifeq (distro,$(IMAGE_CLASS))

distro/homeros-mini: distro/.live-base use/live/textinstall \
	use/homeros use/speech/en use/isohybrid; @:

endif
