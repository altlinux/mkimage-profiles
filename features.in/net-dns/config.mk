use/net-dns: use/net
	@$(call add_feature)
	@$(call xport,NAMESERVERS)

use/net-dns/google: use/net-dns
	@$(call add,NAMESERVERS,8.8.8.8 8.8.4.4)

use/net-dns/google/v6: use/net-dns
	@$(call add,NAMESERVERS,2001:4860:4860::8888)
	@$(call add,NAMESERVERS,2001:4860:4860::8844)

use/net-dns/level3: use/net-dns
	@$(call add,NAMESERVERS,4.2.2.1 4.2.2.2 4.2.2.3)

use/net-dns/yandex: use/net-dns
	@$(call add,NAMESERVERS,77.88.8.8 77.88.8.1)

use/net-dns/yandex/safe: use/net-dns
	@$(call add,NAMESERVERS,77.88.8.88 77.88.8.2)

use/net-dns/yandex/family: use/net-dns
	@$(call add,NAMESERVERS,77.88.8.7 77.88.8.3)
