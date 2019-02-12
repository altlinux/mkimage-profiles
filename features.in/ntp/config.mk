use/ntp: use/services use/pkgpriorities
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(THE_NTPD))
	@$(call add,PINNED_PACKAGES,$$(THE_NTPD))
	@$(call add,DEFAULT_SERVICES_ENABLE,$$(THE_NTPD_SERVICE))
	@$(call try,THE_PACKAGES,openntpd)
	@$(call try,PINNED_PACKAGES,openntpd)
	@$(call try,DEFAULT_SERVICES_ENABLE,ntpd)

use/ntp/client: use/ntp
	@$(call set,THE_NTPD,openntpd)
	@$(call set,THE_NTPD_SERVICE,ntpd)
	@$(call add,NTP_SERVERS,pool.ntp.org)
	@$(call xport,NTP_SERVERS)

use/ntp/chrony: use/ntp
	@$(call set,THE_NTPD,chrony)
	@$(call set,THE_NTPD_SERVICE,chronyd)
