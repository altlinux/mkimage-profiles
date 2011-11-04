# step 4 is kicked off here but actually done by image.in/Makefile

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

export ARCH ?= $(shell arch | sed 's/i686/i586/')

# try not to bog down the system, both CPU and I/O wise
ifdef NICE
START := nice $(shell ionice -c3 echo "ionice -c3" 2>/dev/null)
endif

# it's also nice to know how long and much it takes
START += time -f "%E %PCPU %Mk"

# /usr/bin/{i586,x86_64} are setarch(8) symlinks
START += $(ARCH)

# to be passed into distcfg.mk
IMAGEDIR ?= $(shell [ -d "$$HOME/out" -a -w "$$HOME/out" ] \
	&& echo "$$HOME/out" \
	|| echo "$(BUILDDIR)/out" )

build: profile/populate
	@echo -n "$(TIME) starting image build"
	@if [ -n "$(DEBUG)" ]; then \
		echo ": tail -f $(BUILDLOG)" $(SHORTEN); \
	else \
		if [ -n "$(ALL)" ]; then \
			echo " [$(ALL)]"; \
		else \
			echo " (coffee time)"; \
		fi; \
	fi
	@if $(START) $(MAKE) -C $(BUILDDIR)/ $(LOG); then \
		echo "$(TIME) build done (`tail -1 $(BUILDLOG) | cut -f1 -d. \
			|| echo "no log"`)"; \
	else \
		echo "$(TIME) build failed, see log: $(BUILDLOG)" $(SHORTEN); \
		if [ -z "$(DEBUG)" ]; then \
			echo "$(TIME) (you might want to re-run with DEBUG=1)"; \
		fi; \
		tail -100 "$(BUILDLOG)" | egrep "^E:|[Ee]rror|[Ww]arning"; \
		df -P $(BUILDDIR) | awk 'END { if ($$4 < 1024) \
			{ print "NB: low space on "$$6" ("$$5" used)"}}'; \
	fi
	@if [ -n "$(BELL)" ]; then echo -ne '\a' >&2; fi
