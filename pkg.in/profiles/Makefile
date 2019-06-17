# step 3: copy package profiles referenced in distro configuration
#         (and only those!) over to $(BUILDDIR)

ifndef BUILDDIR
$(error BUILDDIR not defined)
endif

include $(BUILDDIR)/distcfg.mk
SUFFIX := pkg/profiles
TARGET := $(BUILDDIR)/$(SUFFIX)

all: | $(TARGET) $(GLOBAL_DEBUG) copy-profiles grep-archdep
	@mp-commit "$(TARGET)" "requested $(SUFFIX) copied over"

copy-profiles:
	@if [ -n "$(THE_PROFILES)" ]; then \
		cp --parents -at $(TARGET) -- \
			$(addsuffix .directory,$(THE_PROFILES)); \
	fi

### exact copy of a snippet from ../lists/Makefile
grep-archdep: a = $(ARCH)
grep-archdep:
	@# xargs -L 1024 -n 1024 ? -- breaks -I
	@find $(TARGET) -type f \
	| xargs -I '__' sh -c '\
		sed -ri  "s/\\<([^@ ]*)@X86\\>/\\1@i586 \\1@x86_64/g" __; \
		sed -ri  "s/\\<([^@ ]*)@IA32\\>/\\1@i586 i586-\\1@x86_64/g" __;\
		sed -rni "s/\\<([^@ ]*)\\>|\\<([^@ ]*)@$a\\>/\\1\\2/pg" __; \
		sed -ri  "s/\\<([^@ ]*)@[^@ ]+\\> *//g" __'

$(TARGET):
	@mkdir -p $(TARGET)

debug:
	@echo "** THE_PROFILES: $(THE_PROFILES)"
