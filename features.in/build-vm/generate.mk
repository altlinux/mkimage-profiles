# copy tar2vm helper into generated profile to enable standalone builds

all:
	@install -pD $(MKIMAGE_PROFILES)/bin/tar2vm $(BUILDDIR)/bin/tar2vm
