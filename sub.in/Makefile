# step 3: copy the needed subprofiles to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk

all:
	@for dir in $(SUBPROFILES); do \
		rsync -a $$dir/ $(BUILDDIR)/$$dir/ && \
		type -t git >&/dev/null && \
		cd $(BUILDDIR)/$$dir/ && \
		git add . && \
		git commit -qam "$@/$$dir"; \
		cd - >&/dev/null; \
	done ||:

clean:
	@for dir in $(SUBPROFILES); do \
		if [ -n "$$dir" ]; then \
			rm -rf $(BUILDDIR)/$$dir && \
			mkdir -p $(BUILDDIR)/$$dir; \
		fi; \
	done
