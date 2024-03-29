# WARNING: the variable values are stored in build config/log!
use/deflogin:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,shadow-utils passwd)
	@$(call xport,ROOTPW_EMPTY)
	@$(call xport,ROOTPW)
	@$(call xport,USERS)
	@$(call xport,GROUPS)
	@$(call xport,SPEC_USER)
	@$(call xport,LIVE_USER)
	@$(call xport,DEFAULT_SESSION)

# some presets
# USERS variable chunk format is "login:passwd:admin:sudo"
# GROUPS are just stashed there to include USERS logins created

# basic livecd: root with no password, live user is created at startup
use/deflogin/live: use/deflogin
	@$(call set,ROOTPW_EMPTY,1)
	@$(call try,LIVE_USER,altlinux)
	@$(call add,LIVE_PACKAGES,livecd-user)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-user)

# real thing: some control added
use/deflogin/desktop: use/deflogin/live \
	use/deflogin/hardware use/deflogin/xgrp use/deflogin/privileges; @:

# could also be passed on the commandline
use/deflogin/root: use/deflogin
	@$(call try,ROOTPW,altlinux)

# appliances: "root:altlinux"; "altlinux:root" in "xgrp" group
use/deflogin/altlinuxroot: use/deflogin/root use/deflogin/xgrp
	@$(call add,USERS,altlinux:root:1:1)

use/deflogin/altroot: use/deflogin/root use/deflogin/xgrp
	@$(call add,USERS,alt:root:1:1)

# peripherals
use/deflogin/hardware: use/deflogin
	@$(call add,GROUPS,cdwriter cdrom floppy radio scanner uucp)

# videocard and desktop related hardware
use/deflogin/xgrp: use/deflogin
	@$(call add,GROUPS,xgrp audio video camera)

# potentially elevated privileges (NB: _not_ wheel)
use/deflogin/privileges: use/deflogin
	@$(call add,GROUPS,fuse netadmin proc users)
