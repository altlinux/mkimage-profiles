# step 3: copy the needed features to $(BUILDDIR)
#         (only regarding the needed subprofiles)

-include $(BUILDDIR)/.config.mk

# first rsync what's static, and make backups --
# these might signal of file clashes (or plain dirt);
# then handle two more ways of implementing a feature
all:
	@echo "** starting feature configuration"
	@[ -z "$(FEATURES)" ] || \
	for dir in $(sort $(FEATURES)); do \
		for sub in $(SUBPROFILES); do \
			[ -d $$dir/$$sub/ ] && \
			rsync -ab $$dir/$$sub/ $(BUILDDIR)/$$sub/ && { \
				type -t git >&/dev/null && \
				cd $(BUILDDIR)/$$sub/ && \
				git add . && \
				git commit -qam "$@/$$dir/$$sub" ||:; \
				cd - >&/dev/null; \
			} ||:; \
		done; \
		[ -x $$dir/generate.sh ] && { cd $$dir && ./generate.sh; cd -; }; \
		[ -s $$dir/generate.mk ] && $(MAKE) -C $$dir -f generate.mk; \
	done
	@find $(BUILDDIR) -name '*~' ||:

help:
	@echo "** available features:"
	@grep '^use/*' */config.mk | cut -f2 -d:
