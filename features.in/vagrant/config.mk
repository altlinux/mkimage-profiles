use/vagrant: use/vmguest/vbox use/deflogin use/net-ssh use/control
	@$(call add_feature)
	@$(call add,THE_PACKAGES,sudo)
	@$(call add,CONTROL,sudo:public)
	@$(call add,USERS,vagrant:vagrant:1:)	# NB: custom sudoers
	@$(call set,ROOTPW,vagrant)
