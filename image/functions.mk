# prefix pkglist name with its directory to form a path
#list = $(1:%=$(GLOBAL_PKGDIR)/lists/%)
list = $(1:%=pkg/lists/%)
