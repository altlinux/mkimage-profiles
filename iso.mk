pkgs:
	@echo "** starting package lists build process"
	$(MAKE) -C pkg BUILDDIR=$(BUILDDIR)

iso: pkgs
	@echo "** starting image build process"
	@### setup GLOBAL_BOOT_TYPE, etc
	(cd $(BUILDDIR)/image; autoconf; ./configure --with-aptconf=/etc/apt/apt.conf.SS_64)	###
	echo $(MAKE) -C $(BUILDDIR)/image GLOBAL_BUILDDIR=$(BUILDDIR)
	@# check iso size
