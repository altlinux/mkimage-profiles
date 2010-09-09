include $(BUILDDIR)/.config.mk

all:
	ls -l $(BUILDDIR)/.config.mk
	echo -- SUBPROFILES: $(SUBPROFILES)
	for dir in $(SUBPROFILES); do \
		echo -- rsync -a $$dir/ $(BUILDDIR)/$$dir/ && \
		rsync -a $$dir/ $(BUILDDIR)/$$dir/ && \
		cd $(BUILDDIR)/$$dir/ && \
		git add . && \
		git commit -qam "$@/$$dir"; \
		cd ->&/dev/null; \
	done

clean:
	for dir in $(SUBPROFILES); do \
		[ -n "$$dir" ] && \
		rm -rf $(BUILDDIR)/$$dir && \
		mkdir -p $(BUILDDIR)/$$dir ||:; \
	done
