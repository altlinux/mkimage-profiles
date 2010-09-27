# adding boot/isolinux to prereqs is too late here,
# since profile/populate has already finished by now
#
# NB: /usr/bin/{i586,x86_64} are setarch(8) symlinks

iso:
	@echo "** starting image build process"
	$(ARCH) $(MAKE) -C $(BUILDDIR)/ GLOBAL_BUILDDIR=$(BUILDDIR)
