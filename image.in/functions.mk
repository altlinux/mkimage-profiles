ifneq (clean,$(MAKECMDGOALS))
ifneq (distclean,$(MAKECMDGOALS))

ifeq (,$(INCLUDED_FUNCTIONS_MK))
INCLUDED_FUNCTIONS_MK = 1

# globals
PKGDIR ?= $(GLOBAL_BUILDDIR)/pkg

# duplicated from metaprofile makefiles for the sake of "local" builds
ARCH ?= $(shell arch | sed 's/i686/i586/; s/armv.*/arm/')
DATE ?= $(shell date +%Y%m%d)

# prefix pkglist name with its directory to form a path (relative/absolute)
define rlist
$(if $(filter rlist,$(0)),$(1:%=lists/%))
endef

define list
$(if $(filter list,$(0)),$(addprefix $(PKGDIR)/,$(call rlist,$(1))))
endef

# prefix/suffix group name to form a path (relative/absolute)
define rgroup
$(if $(filter rgroup,$(0)),$(1:%=groups/%.directory))
endef

define group
$(if $(filter group,$(0)),$(addprefix $(PKGDIR)/,$(call rgroup,$(1))))
endef

# prefix/suffix pkg profile name to form a path (relative/absolute)
define rprofile
$(if $(filter rprofile,$(0)),$(1:%=profiles/%.directory))
endef

define profile
$(if $(filter profile,$(0)),$(addprefix $(PKGDIR)/,$(call rprofile,$(1))))
endef

# map first argument (a function) onto second one (an argument list)
define map
$(if $(filter map,$(0)),$(foreach a,$(2),$(call $(1),$(a))))
endef

# happens at least twice, and variables are the same by design
define groups2lists
$(if $(filter groups2lists,$(0)),$(shell \
	  if [ -n "$(THE_GROUPS)$(MAIN_GROUPS)" ]; then \
	    sed -rn 's,^X-Alterator-PackageList=(.*)$$,\1,p' \
	    $(call map,group,$(THE_GROUPS) $(MAIN_GROUPS)) | \
	    sed 's/;/\n/g'; \
	  fi; \
))
endef

# kernel package list generation; see also #24669
NULL :=
SPACE := $(NULL) # the officially documented way of getting a space
COMMA := ,

define list2re
$(if $(filter list2re,$(0)),$(subst $(SPACE),|,$(strip $(1))))
endef

# args: KFLAVOURS, KMODULES
# NB: $(2) could be empty
define kpackages
$(if $(filter kpackages,$(0)),$(and $(1), \
	^kernel-(image|modules-($(call list2re,$(2))))-($(call list2re,$(1)))$$))
endef

# arg: branding subpackages
define branding
$(if $(filter branding,$(0)),$(and $(1),^branding-$(BRANDING)-($(call list2re,$(1)))$$))
endef

endif
endif
endif
