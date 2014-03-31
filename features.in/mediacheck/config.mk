use/mediacheck: use/stage2 sub/stage2@mediacheck use/syslinux/mediacheck.cfg
	@$(call add_feature)
	@$(call add,POSTPROCESS_TARGETS,90mediacheck)
