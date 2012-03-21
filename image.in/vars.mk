# dump interesting variables' effective values;
# based on http://stackoverflow.com/questions/7117978

# staged "uninteresting" lists
SPAM := SPAM INIT PREFS DISTCFG DISTCFG_MK
INIT := $(.VARIABLES)
-include $(HOME)/.mkimage/profiles.mk
PREFS := $(.VARIABLES)
-include distcfg.mk
DISTCFG := $(.VARIABLES)

# a separator variable
-- = --

.PHONY: dump-vars

dump-vars:
	$(foreach v, \
	  $(filter-out $(SPAM) $(INIT),$(sort $(PREFS))) -- \
	  $(filter-out $(SPAM) $(PREFS),$(sort $(DISTCFG))), \
	    $(info $(v) = $($(v))))
	@:
