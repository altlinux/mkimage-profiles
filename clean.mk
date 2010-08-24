clean distclean:
	@find -type f -name .config -delete 2>/dev/null ||:
	make -C image $@
