# this makefile holds the most helpful bits for the toplevel one

help/distro:
	@echo '** available distribution targets:'; \
	columnize $(sort $(DISTROS:distro/%=%))

help/ve:
	@echo '** available virtual environment targets:'; \
	columnize $(sort $(VES))

help: | help/distro help/space help/ve; @:
help/space:; @echo
