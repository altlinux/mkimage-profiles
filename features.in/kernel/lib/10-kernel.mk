# step 4: build the distribution image
#         take care for kernel bits

DOT_BASE += $(call kpackages, \
	    $(THE_KMODULES) $(BASE_KMODULES) $(BASE_KMODULES_REGEXP), \
	    $(KFLAVOURS))
