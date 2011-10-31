# step 4 is kicked off here but actually done by image.in/Makefile

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

# NB: /usr/bin/{i586,x86_64} are setarch(8) symlinks

export ARCH ?= $(shell arch | sed 's/i686/i586/')

# to be passed into distcfg.mk
IMAGEDIR ?= $(shell [ -d "$$HOME/out" -a -w "$$HOME/out" ] \
	&& echo "$$HOME/out" \
	|| echo "$(BUILDDIR)/out" )

build: profile/populate
	@echo -n "** starting image build"
	@if [ -n "$(DEBUG)" ]; then \
		echo ": tail -f $(BUILDLOG)" $(SHORTEN); \
	else \
		echo " (coffee time)"; \
	fi
	@if time -f "%E %PCPU %Mk" $(ARCH) \
		$(MAKE) -C $(BUILDDIR)/ $(LOG); \
	then \
		echo "** build done (`tail -1 $(BUILDLOG) | cut -f1 -d. \
			|| echo "no log"`)"; \
	else \
		echo "** build failed, see log: $(BUILDLOG)" $(SHORTEN); \
		if [ -z "$(DEBUG)" ]; then \
			echo "   (you might want to re-run with DEBUG=1)"; \
		fi; \
		tail -100 "$(BUILDLOG)" | egrep "^E:|[Ee]rror|[Ww]arning"; \
		df -P $(BUILDDIR) | awk 'END { if ($$4 < 1024) \
			{ print "** NB: low space on "$$6" ("$$5" used)"}}'; \
	fi
	@if [ -n "$(BELL)" ]; then echo -ne '\a' >&2; fi
