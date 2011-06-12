# step 3: copy package lists and groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

all:
	for dir in lists groups; do \
		$(MAKE) -C $$dir BUILDDIR=$(BUILDDIR); \
	done
