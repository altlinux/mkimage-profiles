include $(BUILDDIR)/.config.mk

# make rsync backups
all:
	@for dir in $(FEATURES); do \
		for sub in $(SUBPROFILES); do \
			dest=$${sub%stage1}; \
			[ -d $$dir/$$sub/ ] && \
			rsync -ab $$dir/$$sub/ $(BUILDDIR)/$$dest/ && \
			cd $(BUILDDIR)/$$dest/ && \
			git add . && \
			git commit -qam "$@/$$dir/$$sub" && \
			cd ->&/dev/null; \
		done; \
	done
	@# these might signal of file clashes (or plain dirt)
	@find $(BUILDDIR) -name '*~'
