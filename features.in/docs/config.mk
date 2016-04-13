# copy the packaged docs to image root
# packaged documentation sources:
# 1) branding-*-indexhtml
# 2) docs-* (should be installed elsewhere)

+docs: use/docs; @:

use/docs:
	@$(call add_feature)

use/docs/indexhtml: use/docs use/branding
	@$(call add,THE_BRANDING,indexhtml)

use/docs/manual: use/docs
	@$(call xport,DOCS)
	@$(call add,THE_PACKAGES,docs-$$(DOCS))

use/docs/license: use/docs use/branding
	@$(call add,THE_BRANDING,notes)

use/docs/full: use/docs/indexhtml use/docs/manual use/docs/license; @:
