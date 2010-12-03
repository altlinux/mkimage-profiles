# step 3: copy package lists and groups referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

all:
	for dir in lists groups; do \
		$(MAKE) -C $$dir BUILDDIR=$(BUILDDIR); \
	done
