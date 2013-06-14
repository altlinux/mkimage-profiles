# WARNING: the variable values are stored in build config/log!
use/deflogin:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,shadow-utils)
	@$(call xport,ROOTPW)
	@$(call xport,USERS)
	@$(call xport,GROUPS)

# some presets
# USERS variable chunk format is "login:passwd:admin:sudo"
# GROUPS are just stashed there to include USERS logins created

# livecd: root and altlinux users with no password at all
use/deflogin/empty: use/deflogin use/deflogin/altlinux
	@$(call set,ROOTPW,)
	@$(call add,USERS,altlinux::1:1)

# mostly used to allow access to videocard and desktop related hardware
use/deflogin/xgrp: use/deflogin
	@$(call add,GROUPS,xgrp)

# appliances: "root:altlinux"; "altlinux:root" in "xgrp" group
use/deflogin/altlinuxroot: use/deflogin/xgrp
	@$(call try,ROOTPW,altlinux)
	@$(call add,USERS,altlinux:root:1:1)

# could also be passed on the commandline
use/deflogin/root: use/deflogin
	@$(call try,ROOTPW,altlinux)
