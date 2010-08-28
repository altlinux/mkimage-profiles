iso:
	@echo "** starting image build process"
	@### setup GLOBAL_BOOT_TYPE, etc
	i586 make -C $(BUILDDIR) GLOBAL_BUILDDIR=$(BUILDDIR)
	@# check iso size
