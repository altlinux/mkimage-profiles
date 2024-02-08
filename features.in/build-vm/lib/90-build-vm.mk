# step 4: build the virtual machine image

IMAGE_PACKAGES = $(DOT_BASE) \
		 $(SYSTEM_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES) \
		 $(THE_PACKAGES) \
		 $(call list,$(BASE_LISTS) $(THE_LISTS) $(COMMON_LISTS))

IMAGE_PACKAGES_REGEXP = $(THE_PACKAGES_REGEXP) \
                        $(BASE_PACKAGES_REGEXP)

ifneq (,$(EFI_BOOTLOADER))
VM_BOOTLOADER=$(EFI_BOOTLOADER)
else
VM_BOOTLOADER=$(BASE_BOOTLOADER)
endif

# intermediate chroot archive
VM_TARBALL := $(IMAGE_OUTDIR)/$(IMAGE_NAME).tar
VM_OUT_TARBALL := $(IMAGE_OUTDIR)/$(IMAGE_OUTNAME).tar
VM_RAWDISK := $(IMAGE_OUTDIR)/$(IMAGE_NAME).raw
VM_FSTYPE ?= ext4
VM_SIZE ?= 0

VM_GZIP_COMMAND ?= gzip -f
VM_XZ_COMMAND ?= xz -T0 -f

# tavolga
RECOVERY_LINE ?= Press ENTER to start

# tarball save
ifneq (,$(VM_SAVE_TARBALL))
ifeq (,$(filter-out img img.xz qcow2 qcow2c vdi vmdk vhd,$(IMAGE_TYPE)))
ifeq (,$(filter-out tar tar.gz tar.xz,$(VM_SAVE_TARBALL)))
SAVE_TARBALL := convert-image/$(VM_SAVE_TARBALL)
endif
endif
endif

check-sudo:
	@if ! type -t sudo >&/dev/null; then \
		echo "** error: sudo not available, see doc/vm.txt" >&2; \
	fi

check-qemu:
	@if ! type -t qemu-img >&/dev/null; then \
		echo "** error: qemu-img not available" >&2; \
		exit 1; \
	fi

tar2fs: $(SAVE_TARBALL) check-sudo prepare-tarball-qemu
	@if [ -x /usr/share/mkimage-profiles/bin/tar2fs ]; then \
		TOPDIR=/usr/share/mkimage-profiles; \
	else \
		[ -z "$(MKIMAGE_PROFILES)" ] || TOPDIR=$(MKIMAGE_PROFILES); \
	fi; \
	if ! sudo $$TOPDIR/bin/tar2fs \
		"$(VM_TARBALL)" "$(VM_RAWDISK)" "$(VM_SIZE)" "$(VM_FSTYPE)" \
			"$(VM_BOOTLOADER)" "$(ARCH)" "$(VM_PARTTABLE)" \
			"$(VM_BOOTTYPE)" "$(VM_BOOTSIZE)"; then \
		echo "** error: sudo tar2fs failed, see build log" >&2; \
		exit 1; \
	fi

# copy $(BUILDDIR)/.work/chroot/.host/qemu* into chroot if qemu is used
prepare-tarball-qemu:
	@(cd "$(BUILDDIR)/.work/chroot/"; \
		tar -rf "$(VM_TARBALL)" ./.host/qemu*) ||:

convert-image/tar:
ifneq (,$(SAVE_TARBALL))
	cp "$(VM_TARBALL)" "$(VM_OUT_TARBALL)"
else
	mv "$(VM_TARBALL)" "$(VM_OUT_TARBALL)"
endif

convert-image/tar.gz: convert-image/tar
	$(VM_GZIP_COMMAND) "$(VM_OUT_TARBALL)"

convert-image/tar.xz: convert-image/tar
	$(VM_XZ_COMMAND) "$(VM_OUT_TARBALL)"

convert-image/img: tar2fs
	mv "$(VM_RAWDISK)" "$(IMAGE_OUTPATH)"

convert-image/img.xz: tar2fs
	$(VM_XZ_COMMAND) < "$(VM_RAWDISK)" > "$(IMAGE_OUTPATH)"

convert-image/qcow2 convert-image/qcow2c convert-image/vmdk \
	convert-image/vdi convert-image/vhd: check-qemu tar2fs
	@VM_COMPRESS=; \
	case "$(IMAGE_TYPE)" in \
	"vhd") VM_FORMAT="vpc";; \
	"qcow2c") VM_FORMAT="qcow2"; VM_COMPRESS="-c";; \
	*) VM_FORMAT="$(IMAGE_TYPE)"; \
	esac; \
	qemu-img convert $$VM_COMPRESS -O "$$VM_FORMAT" \
		"$(VM_RAWDISK)" "$(IMAGE_OUTPATH)"

# for tavolga
convert-image/recovery.tar:
	build-recovery-tar \
	    --image-name $(IMAGE_NAME) \
	    --date $(DATE) \
	    --compress-command '$(VM_GZIP_COMMAND)' \
	    --rootfs "$(VM_TARBALL)" \
	    --output "$(IMAGE_OUTPATH)" \
	    --line '$(RECOVERY_LINE)'

post-convert:
	@rm -f "$(VM_RAWDISK)"; \
	if [ "0$(DEBUG)" -le 1 ]; then rm -f "$(VM_TARBALL)"; fi

convert-image: convert-image/$(IMAGE_TYPE) post-convert; @:

run-image-scripts: GLOBAL_CLEANUP_PACKAGES := $(CLEANUP_PACKAGES)

# override
pack-image: MKI_PACK_RESULTS := tar:$(VM_TARBALL)

all: $(GLOBAL_DEBUG) \
	build-image copy-subdirs copy-tree run-image-patches run-image-scripts \
	pack-image convert-image postprocess $(GLOBAL_CLEAN_WORKDIR)
