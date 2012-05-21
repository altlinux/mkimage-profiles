# globals
PKGDIR := $(GLOBAL_BUILDDIR)/pkg

# duplicated from metaprofile makefiles for the sake of "local" builds
ARCH ?= $(shell arch | sed 's/i686/i586/; s/armv.*/arm/; s/ppc.*/ppc/')
DATE ?= $(shell date +%Y%m%d)

# prefix pkglist name with its directory to form a path (relative/absolute)
rlist = $(1:%=lists/%)
list  = $(addprefix $(PKGDIR)/,$(call rlist,$(1)))

# prefix/suffix group name to form a path (relative/absolute)
rgroup = $(1:%=groups/%.directory)
group  = $(addprefix $(PKGDIR)/,$(call rgroup,$(1)))

# map first argument (a function) onto second one (an argument list)
map = $(foreach a,$(2),$(call $(1),$(a)))

# kernel package list generation; see also #24669
NULL :=
SPACE := $(NULL) # the officially documented way of getting a space
COMMA := ,

list2re = $(subst $(SPACE),|,$(strip $(1)))

# args: KFLAVOURS, KMODULES
# NB: $(2) could be empty
kpackages = $(and $(1), \
	^kernel-(image|modules-($(call list2re,$(2))))-($(call list2re,$(1)))$$)

# arg: branding subpackages
branding = $(and $(1),^branding-$(BRANDING)-($(call list2re,$(1)))$$)
