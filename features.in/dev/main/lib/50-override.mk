# only MAIN_* should go in this time

IMAGE_PACKAGES_REGEXP = $(MAIN_PACKAGES_REGEXP)
IMAGE_PACKAGES = $(MAIN_PACKAGES) $(call map,list,$(MAIN_LISTS))
