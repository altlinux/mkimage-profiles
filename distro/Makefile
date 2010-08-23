clean:
	@:> config.mk

distclean:
	@rm config.mk

bare: clean
	@echo BASE_LISTS='base kernel' >> config.mk

server-base: bare
	@echo BASE_LISTS+='server-base' >> config.mk

server-light: server-base
	@echo BASE_LISTS+='kernel-wifi' >> config.mk
