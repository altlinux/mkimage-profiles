# this makefile is designed to be included in toplevel one
ifdef BUILDDIR

# step 4 is kicked off here but actually done by image.in/Makefile
#
# adding boot/isolinux to prereqs is too late here,
# since profile/populate target is already done by now
#
# NB: /usr/bin/{i586,x86_64} are setarch(8) symlinks

iso:
	@echo -n "** starting image build"
	@if test -n "$(DEBUG)"; then \
		echo ": see $(BUILDLOG)"; \
	else \
		echo " (coffee time)"; \
	fi
	@if time $(ARCH) \
		$(MAKE) -C $(BUILDDIR)/ GLOBAL_BUILDDIR=$(BUILDDIR) $(LOG); \
	then \
		echo "** build done (`tail -2 $(BUILDLOG) \
			| sed -n 's,^.* \([0-9:]\+\)\...elapsed.*$$,\1,p' \
			|| echo "no log"`)"; \
	else \
		echo "** build failed, see log: $(BUILDLOG)"; \
		if test -z "$(DEBUG)"; then \
			echo "   (you might want to re-run with DEBUG=1)"; \
		fi; \
		tail -100 "$(BUILDLOG)" | grep "^E:"; \
	fi

endif
