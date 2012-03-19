# this makefile holds the most helpful bits for the toplevel one

help/distro:
	@echo '** available distribution targets:'; \
	echo $(DISTROS) | fmt -sw"$$((COLUMNS>>1))" | column -t

help/ve:
	@echo '** available virtual environment targets:'; \
	echo $(VES) | fmt -sw"$$((COLUMNS>>1))" | column -t

help: | help/distro help/space help/ve; @:
help/space:; @echo
