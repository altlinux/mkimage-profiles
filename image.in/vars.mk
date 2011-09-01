# dump interesting variables' effective values;
# based on http://stackoverflow.com/questions/7117978

SPAM := $(.VARIABLES)
-include distcfg.mk
HAM := $(.VARIABLES)

.PHONY: dump-vars

dump-vars:
	$(foreach v, \
	  $(filter-out $(SPAM) SPAM,$(sort $(HAM))), \
	    $(info $(v) = $($(v))))
	@:
