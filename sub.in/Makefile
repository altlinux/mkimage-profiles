# step 3: copy the needed subprofiles to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk

# if the subprofile is specified in src/dst notation,
# take src/ and put it as dst/ (for stage2 variants)
all:
	@for sub in $(SUBPROFILES); do \
		src="$${sub%/*}" && \
		dst="$${sub#*/}" && \
		rsync -a "$$src/" "$(BUILDDIR)/$$dst/" && \
		type -t git >&/dev/null && \
		cd "$(BUILDDIR)/$$dst/" && \
		git add . && \
		git commit -qam "$$sub"; \
		cd - >&/dev/null; \
	done

clean:
	@for sub in $(SUBPROFILES); do \
		dst="${sub#*/}" && \
		if [ -n "$$dst" ]; then \
			rm -rf "$(BUILDDIR)/$$dst" && \
			mkdir -p "$(BUILDDIR)/$$dst"; \
		fi; \
	done
