PKGDIR=$(GLOBAL_BUILDDIR)/pkg

# prefix pkglist name with its directory to form a path
list = $(1:%=$(PKGDIR)/lists/%)

# prefix/suffix group name to form a path
group = $(1:%=$(PKGDIR)/groups/%.directory)
