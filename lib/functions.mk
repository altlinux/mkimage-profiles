# NB: don"t use ANY quotes ('/") for put()/add()/set() arguments!
# shell will get confused by ' or args get spammed with "

# pay attention to the context functions get called in:
# e.g. features.in/syslinux/config.mk introduces conditionals

# this one adds whatever is given as an argument
put = $(and $(1),$(put_body))
define put_body
{ $(log_body); \
printf '%s\n' '$(1)' >> "$(CONFIG)"; }
endef

# these three take two args
# add() just appends an additive rule...
add = $(and $(1),$(2),$(add_body))
define add_body
$(if $(filter GLOBAL_% INFO_%,$(1)),$(warning add,$(1) might be a problem)) \
{ $(log_body); \
printf '%s += %s\n' '$(1)' '$(2)' >> "$(CONFIG)"; }
endef

# ...set() comments out any previous definition
# and then appends an assigning rule...
# NB: $(2) could be empty
set = $(and $(1),$(set_body))
define set_body
{ $(log_body); \
sed -i 's|^$(1)[ 	]*[+?]*=.*$$|#& # overridden by $@|' "$(CONFIG)"; \
printf '%s = %s\n' '$(1)' '$(2)' >> "$(CONFIG)"; }
endef

# try() appends a conditionally-assigning rule
try = $(and $(1),$(2),$(try_body))
define try_body
{ $(log_body); \
printf '%s ?= %s\n' '$(1)' '$(2)' >> "$(CONFIG)"; }
endef

# xport() requests a variable to be exported to the scripts
# NB: immediate assignment would break accumulators like USERS
xport = $(and $(1),$(xport_body))
define xport_body
{ $(log_body); \
v='$(1:GLOBAL_%=%)'; \
printf 'export GLOBAL_%s = $$(%s)\n' "$$v" "$$v" >> "$(CONFIG)"; }
endef

# if the rule being executed isn't logged yet, log it
define log_body
{ [ -s "$(CONFIG)" ] && \
	grep -q '^# $@$$' "$(CONFIG)" || printf '# %s\n' '$@' >> "$(CONFIG)"; }
endef

# in a use/feature/particularly target, we need a "feature" bit
add_feature = $(call add,FEATURES,$(word 2,$(subst /, ,$@)))

# convert tag list into a list of relative package list paths
# NB: tags can do boolean expressions: (tag1 && !(tag2 || tag3))
tags = $(and $(strip $(1)),$(addprefix tagged/,$(shell echo "$(1)" \
       | tags2lists pkg.in/lists/tagged)))

# toplevel Makefile convenience
addsuffices = $(foreach s,$(1),$(call addsuffix,$s,$(2)))
