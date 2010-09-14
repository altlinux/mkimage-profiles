include $(BUILDDIR)/.config.mk

SHELL += -x

# first rsync what's static, and make backups --
# these might signal of file clashes (or plain dirt);
# then handle two more ways of implementing a feature
all:
	@echo "** starting feature configuration"
	@[ -z $(FEATURES) ] || \
	for dir in $(sort $(FEATURES)); do \
		for sub in $(SUBPROFILES); do \
			[ -d $$dir/$$sub/ ] && \
			rsync -ab $$dir/$$sub/ $(BUILDDIR)/$$sub/ && { \
				cd $(BUILDDIR)/$$sub/ && \
				git add . && \
				git commit -qam "$@/$$dir/$$sub" ||:; \
				cd - >&/dev/null; \
			}; \
		done; \
		[ -x $$dir/generate.sh ] && { cd $$dir && ./generate.sh; cd -; }; \
		[ -s $$dir/generate.mk ] && $(MAKE) -C $$dir -f generate.mk; \
	done
	@find $(BUILDDIR) -name '*~' ||:
