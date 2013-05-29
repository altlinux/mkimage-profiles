# copy tar2fs helper into generated profile to enable standalone builds

all:
	@install -pD $(MKIMAGE_PROFILES)/bin/tar2fs $(BUILDDIR)/bin/tar2fs
