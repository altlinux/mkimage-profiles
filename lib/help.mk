# this makefile holds the most helpful bits for the toplevel one

ifdef __frontend
define help_body
	@for i in $(2); do echo $$i; done
endef
else
define help_body
	@echo '** available $(1) targets:'; \
	columnize $(2)
endef
endif

help = $(and $(2),$(help_body))

help/distro:
	$(call help,distribution,$(sort $(DISTROS:distro/%=%)))

help/ve:
	@echo '** available virtual environment targets:'; \
	columnize $(sort $(VES))

help: | help/distro help/space help/ve; @:
help/space:; @echo
