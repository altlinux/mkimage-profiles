# adding boot/isolinux to prereqs is too late here,
# since profile/populate has already finished by now
iso:
	@echo "** starting image build process"
	@(cd $(BUILDDIR)/; autoconf; ./configure --with-aptconf=$(HOME)/apt/apt.conf)	###
	$(MAKE) -C $(BUILDDIR)/ GLOBAL_BUILDDIR=$(BUILDDIR)
