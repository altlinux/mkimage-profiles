# this makefile contains some syntactic sugar for the toplevel one

# strip prefix
config/with/%: %; @:

# just map to specific features
config/like/%: use/build-%; @:

# map and preconfigure
config/pack/%: use/pack/%
	@$(call set,IMAGE_TYPE,$*)

# just preconfigure
config/name/%:
	@$(call set,IMAGE_NAME,$*)

# request particular image subprofile inclusion
sub/%:
	@$(call add,SUBPROFILES,$(@:sub/%=%))

# the final thing will pull the rest in
build: postclean; @:
