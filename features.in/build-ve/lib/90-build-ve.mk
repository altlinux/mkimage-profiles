# step 4: build the virtual environment image

ifeq (tar,$(IMAGE_PACKTYPE))
MKI_TAR_COMPRESS = $(IMAGE_COMPRESS)
endif

ifeq (cpio,$(IMAGE_PACKTYPE))
MKI_CPIO_COMPRESS = $(IMAGE_COMPRESS)
endif

# some VEs _can_ contain kernels (think ARM multiboot
# but this can also help VE/VM hybrid images)
IMAGE_PACKAGES = $(DOT_BASE) \
		 $(SYSTEM_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES) \
		 $(THE_PACKAGES) \
		 $(call list,$(BASE_LISTS) $(THE_LISTS))

all: $(GLOBAL_DEBUG) build-image copy-tree run-image-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)
