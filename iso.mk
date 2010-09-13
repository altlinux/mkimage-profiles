iso:
	@echo "** starting image build process"
	@### setup GLOBAL_BOOT_TYPE, etc
	(cd $(BUILDDIR)/; autoconf; ./configure --with-aptconf=$(HOME)/apt/apt.conf)	###
	$(MAKE) -C $(BUILDDIR)/ GLOBAL_BUILDDIR=$(BUILDDIR)
	@# check iso size
