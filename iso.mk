# step 4 is kicked off here but actually done by image.in/Makefile
#
# adding boot/isolinux to prereqs is too late here,
# since profile/populate target is already done by now
#
# NB: /usr/bin/{i586,x86_64} are setarch(8) symlinks

iso:
	@echo "** starting image build process"
	$(ARCH) $(MAKE) -C $(BUILDDIR)/ GLOBAL_BUILDDIR=$(BUILDDIR)
