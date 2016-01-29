use/control:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,control)
	@$(call xport,CONTROL)

# some presets
use/control/sudo-su: use/control
	@$(call add,CONTROL,su:public sudo:public)

# recommended by ldv@ ;-)
# note that:
# - sshd-allow-groups results in "AllowGroups wheel users"
# - unprivileged su is used to drop privileges, not gain those
use/control/server/ldv: use/control
	@$(call add,CONTROL,mount:unprivileged)
	@$(call add,CONTROL,passwdqc-enforce:everyone)
	@$(call add,CONTROL,ping:netadmin)
	@$(call add,CONTROL,ping6:restricted)
	@$(call add,CONTROL,postqueue:mailadm)
	@$(call add,CONTROL,sftp:disabled)
	@$(call add,CONTROL,sshd-allow-groups:enabled)
	@$(call add,CONTROL,sshd-password-auth:disabled)
	@$(call add,CONTROL,su:restricted)
