# this makefile holds the most helpful bits for the toplevel one

define help_body
if [ -t 1 ]; then \
	echo '** available $(1) targets:'; \
	columnize $(2); \
else \
	printf '%s\n' $(2); \
fi
endef

help = $(and $(2),$(help_body))

help/distro:
	@$(call help,distribution,$(sort $(DISTROS:distro/%=%)))

help/ve:
	@[ -n "$(SPACE)" ] && echo; \
	$(call help,virtual environment,$(sort $(VES)))

help/vm:
	@[ -n "$(SPACE)" ] && echo; \
	$(call help,virtual machine,$(sort $(VMS)))

help: SPACE = 1
help: help/distro help/ve help/vm; @:
