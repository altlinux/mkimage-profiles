use/office:
	@$(call add_feature)
	@$(call try,THE_OFFICE,abiword gnumeric)
	@$(call add,THE_PACKAGES,$$(THE_OFFICE))

# support both LibreOffice and LibreOffice-still
use/office/LibreOffice: use/office
	@$(call set,THE_OFFICE,LibreOffice$$(LO_FLAVOUR))

# the complete lack of dependencies is intentional
use/office/LibreOffice/still:
	@$(call set,LO_FLAVOUR,-still)

use/office/LibreOffice/lang: use/office/LibreOffice
	@$(call add,THE_OFFICE,LibreOffice$$(LO_FLAVOUR)-langpack-kk)
	@$(call add,THE_OFFICE,LibreOffice$$(LO_FLAVOUR)-langpack-ru)
	@$(call add,THE_OFFICE,LibreOffice$$(LO_FLAVOUR)-langpack-uk)

use/office/LibreOffice/gtk2 use/office/LibreOffice/gtk3 \
	use/office/LibreOffice/qt5 use/office/LibreOffice/kde5: \
	use/office/LibreOffice/%: use/office/LibreOffice
	@$(call add,THE_OFFICE,LibreOffice$$(LO_FLAVOUR)-$*)

use/office/calligra: use/office
	@$(call set,THE_OFFICE,calligra)
