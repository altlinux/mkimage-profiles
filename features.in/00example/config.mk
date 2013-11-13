# this Makefile snippet gets included from toplevel distro.mk;
# it can add additional targets which could then be used there,
# and which can depend on other targets defined in any makefile
# included from toplevel Makefile
#
# see also toplevel functions.mk for the "add" function definition,
# and distro.mk for usage examples
#
# for somewhat more involved example, see syslinux feature

use/00example: use/repo/main use/anotherfeature
	@$(call add_feature)
	@$(call add,MAIN_PACKAGES,hello)
