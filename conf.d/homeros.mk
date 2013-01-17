
ifeq (distro,$(IMAGE_CLASS))

distro/homeros-nano: distro/.live-base use/live/textinstall use/homeros; @:

endif
