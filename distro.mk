sub/%:
	echo SUBDIRS+=$(@:sub/%=%) >> .config

init:
	:> .config

distro/bare: init sub/install2
	echo BASE_LISTS='base kernel' >> .config

distro/server-base: distro/bare sub/main
	echo BASE_LISTS+='server-base kernel-server' >> .config
	@#echo DISTRO_TRACE+=$@ >> .config

distro/server-light: distro/server-base sub/disk
	echo BASE_LISTS+='kernel-wifi' >> .config
	@#echo DISTRO_TRACE+=$@ >> .config
