include $(BUILDDIR)/.config.mk

all:
	@for dir in $(SUBPROFILES); do \
		rsync -a $$dir/ $(BUILDDIR)/$$dir/ && \
		cd $(BUILDDIR)/$$dir/ && \
		git add . && \
		git commit -qam "$@/$$dir"; \
		cd ->&/dev/null; \
	done

clean:
	@for dir in $(SUBPROFILES); do \
		[ -n "$$dir" ] && \
		rm -rf $(BUILDDIR)/$$dir && \
		mkdir -p $(BUILDDIR)/$$dir ||:; \
	done
