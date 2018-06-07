use/ntp: use/services use/pkgpriorities
	@$(call add_feature)
	@$(call add,THE_PACKAGES,openntpd)
	@$(call add,PINNED_PACKAGES,openntpd)
	@$(call add,DEFAULT_SERVICES_ENABLE,ntpd)

use/ntp/client: use/ntp
	@$(call add,NTP_SERVERS,pool.ntp.org)
	@$(call xport,NTP_SERVERS)
