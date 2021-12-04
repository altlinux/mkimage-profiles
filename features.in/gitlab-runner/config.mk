# WARNING: the variable values are stored in build config/log!
use/gitlab-runner:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,shadow-utils passwd curl)
	@$(call xport,GL_USER)
	@$(call xport,GL_SSH_KEY)

# some presets
# USERS variable chunk format is "login:passwd:admin:sudo"
# GROUPS are just stashed there to include USERS logins created
# GL_SSH_KEY should be changed accordingly
use/gitlab-runner/defuser: use/gitlab-runner
	@$(call add,GL_USER,gitlab-runner)
