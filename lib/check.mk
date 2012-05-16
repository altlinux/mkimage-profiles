ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

check:
	@find sub.in features.in \
		-path '*scripts.d/*' \
		\! \( -perm 755 -o -name .gitignore \) \
	| while read line; do \
		echo "chmod 755 $$line"; \
	done
	@find features.in -maxdepth 1 -type d \
	| while read dir; do \
		if [ ! -s "$$dir/README" ]; then \
			echo "$$dir: missing README"; \
		fi; \
	done
