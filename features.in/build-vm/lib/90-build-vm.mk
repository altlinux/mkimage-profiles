# step 4: build the virtual machine image

IMAGE_PACKAGES = $(SYSTEM_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES) \
		 $(THE_PACKAGES) \
		 $(call list,$(BASE_LISTS) $(THE_LISTS)) \
		 $(call kpackages,$(THE_KMODULES) $(BASE_KMODULES),$(KFLAVOURS))

# intermediate chroot archive
VM_TARBALL := $(IMAGE_OUTDIR)/$(IMAGE_NAME).tar

check-sudo:
	@if ! type -t sudo >&/dev/null; then \
		echo "** error: sudo not available, see doc/vm.txt" >&2; \
		exit 1; \
	fi

convert-image: check-sudo
	@if ! sudo $(TOPDIR)/bin/tar2vm \
		"$(VM_TARBALL)" "$(IMAGE_OUTPATH)" $$VM_SIZE; then \
		echo "** error: sudo tar2vm failed, see also doc/vm.txt" >&2; \
		exit 1; \
	fi

run-image-scripts: GLOBAL_ROOTPW := $(ROOTPW)

pack-image: MKI_PACK_RESULTS := tar:$(VM_TARBALL)

all: $(GLOBAL_DEBUG) build-image copy-tree run-image-scripts pack-image \
	convert-image postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: imagedir
