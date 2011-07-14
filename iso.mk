# this makefile is designed to be included in toplevel one
ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

export ARCH ?= $(shell arch | sed 's/i686/i586/')

# step 4 is kicked off here but actually done by image.in/Makefile
#
# adding boot/isolinux to prereqs is too late here,
# since profile/populate target is already done by now
#
# NB: /usr/bin/{i586,x86_64} are setarch(8) symlinks

iso:
	@echo -n "** starting image build"
	@if test -n "$(DEBUG)"; then \
		echo ": tail -f $(BUILDLOG)" $(SHORTEN); \
	else \
		echo " (coffee time)"; \
	fi
	@if time -f "%E %PCPU %Mk" $(ARCH) \
		$(MAKE) -C $(BUILDDIR)/ GLOBAL_BUILDDIR=$(BUILDDIR) $(LOG); \
	then \
		echo "** build done (`tail -1 $(BUILDLOG) | cut -f1 -d. \
			|| echo "no log"`)"; \
	else \
		echo "** build failed, see log: $(BUILDLOG)" $(SHORTEN); \
		if test -z "$(DEBUG)"; then \
			echo "   (you might want to re-run with DEBUG=1)"; \
		fi; \
		tail -100 "$(BUILDLOG)" | egrep "^E:|[Ee]rror|[Ww]arning"; \
	fi
