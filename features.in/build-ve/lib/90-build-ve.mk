# step 4: build the virtual environment image

ifeq (tar,$(IMAGE_PACKTYPE))
MKI_TAR_COMPRESS = $(IMAGE_COMPRESS)
endif

ifeq (cpio,$(IMAGE_PACKTYPE))
MKI_CPIO_COMPRESS = $(IMAGE_COMPRESS)
endif

ifeq (squash,$(IMAGE_PACKTYPE))
pack-image: CLEANUP_OUTDIR=
endif

# some VEs _can_ contain kernels (think ARM multiboot
# but this can also help VE/VM hybrid images)
IMAGE_PACKAGES = $(DOT_BASE) \
		 $(SYSTEM_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES) \
		 $(THE_PACKAGES) \
		 $(call list,$(BASE_LISTS) $(THE_LISTS) $(COMMON_LISTS))

IMAGE_PACKAGES_REGEXP = $(THE_PACKAGES_REGEXP) \
                        $(BASE_PACKAGES_REGEXP)

all: $(GLOBAL_DEBUG) \
	build-image copy-subdirs copy-tree run-image-patches run-image-scripts \
	pack-image postprocess $(GLOBAL_CLEAN_WORKDIR)
