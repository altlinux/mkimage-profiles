# step 4: build the virtual machine image

IMAGE_PACKAGES = $(DOT_BASE) \
		 $(SYSTEM_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES) \
		 $(THE_PACKAGES) \
		 $(call list,$(BASE_LISTS) $(THE_LISTS))

# intermediate chroot archive
VM_TARBALL := $(IMAGE_OUTDIR)/$(IMAGE_NAME).tar
VM_RAWDISK := $(IMAGE_OUTDIR)/$(IMAGE_NAME).raw
VM_FSTYPE ?= ext4
VM_SIZE ?= 0

check-sudo:
	@if ! type -t sudo >&/dev/null; then \
		echo "** error: sudo not available, see doc/vm.txt" >&2; \
		exit 1; \
	fi

prepare-image: check-sudo
	@if ! sudo $(TOPDIR)/bin/tar2fs \
		"$(VM_TARBALL)" "$(VM_RAWDISK)"  $(VM_SIZE) $(VM_FSTYPE); then \
		echo "** error: sudo tar2fs failed, see also doc/vm.txt" >&2; \
		exit 1; \
	fi

convert-image: prepare-image
	@case "$(IMAGE_TYPE)" in \
	"img") mv "$(VM_RAWDISK)" "$(IMAGE_OUTPATH)"; exit 0;; \
	"vhd") VM_FORMAT="vpc";; \
	*) VM_FORMAT="$(IMAGE_TYPE)"; \
	esac; \
	if ! type -t qemu-img >&/dev/null; then \
		echo "** warning: qemu-img not available" >&2; \
	else \
		qemu-img convert -O "$$VM_FORMAT" \
			"$(VM_RAWDISK)" "$(IMAGE_OUTPATH)"; \
		rm "$(VM_RAWDISK)"; \
		if [ -z "$(DEBUG)" ]; then rm "$(VM_TARBALL)"; fi; \
	fi

run-image-scripts: GLOBAL_CLEANUP_PACKAGES := $(CLEANUP_PACKAGES)

# override
pack-image: MKI_PACK_RESULTS := tar:$(VM_TARBALL)

all: $(GLOBAL_DEBUG) build-image copy-tree run-image-scripts pack-image \
	convert-image postprocess $(GLOBAL_CLEAN_WORKDIR)
