# step 3: copy the needed subprofiles to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk

# if the subprofile is specified in src/dst notation,
# take src/ and put it as dst/ (for stage2 variants)
# NB: rootfs may come in first
all:
	@for sub in $(SUBPROFILES); do \
		src="$${sub%@*}" && \
		dst="$${sub#*@}" && \
		neq="$${src#$$dst}" && \
		dstdir=""$(BUILDDIR)/$$dst/"" && \
		if [ -d "$$dstdir" ]; then \
			action="complemented"; \
		else \
			action="initialized"; \
		fi; \
		rsync -qa "$$src/" "$(BUILDDIR)/$$dst/" && \
		mp-commit "$(BUILDDIR)/$$dst/" \
			"$$dst subprofile $$action$${neq:+ (using $$src)}"; \
	done

clean:
	@for sub in $(SUBPROFILES); do \
		dst="${sub#*@}" && \
		if [ -n "$$dst" -a -n "$(BUILDDIR)" ]; then \
			rm -r "$(BUILDDIR)/$$dst" && \
			mkdir -p "$(BUILDDIR)/$$dst"; \
		fi; \
	done
