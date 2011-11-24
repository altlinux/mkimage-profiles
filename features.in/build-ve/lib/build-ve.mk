# step 4: build the virtual environment image

ifeq (tar,$(IMAGE_PACKTYPE))
MKI_TAR_COMPRESS = $(IMAGE_COMPRESS)
endif

ifeq (cpio,$(IMAGE_PACKTYPE))
MKI_CPIO_COMPRESS = $(IMAGE_COMPRESS)
endif

IMAGE_PACKAGES = $(call list,$(BASE_LISTS)) \
		 $(SYSTEM_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES)

all: $(GLOBAL_DEBUG) build-image copy-tree run-image-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: imagedir
