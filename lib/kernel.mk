ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

# choose std kernel flavour for max RAM size support
ifeq (i586,$(ARCH))
BIGRAM := std-pae
else
BUGRAM := std-def
endif
