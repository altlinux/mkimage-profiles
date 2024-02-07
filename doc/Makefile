# build asciidoc books

ifneq (,$(BUILDDIR))
DEST = -D "$(BUILDDIR)"
endif

ifneq (,$(DEBUG))
VERBOSE = --verbose
endif

# avoid common DEBUG for the time being
-include $(HOME)/.mkimage/profiles.mk

PROJECT = mkimage-profiles
TOPLEVEL_DOC = $(PROJECT).asciidoc

A2X = a2x
FXC = .fop.xconf

L = ru
DEPTH = 3

# common args (and the source file to process) come last
XSLT_ARGS = --stringparam toc.max.depth $(DEPTH)
COMMON_ARGS = -d book -a lang="$L" $(DEST) $(VERBOSE) $(TOPLEVEL_DOC)
HTML_ARGS = -a data-uri --icons -r . \
	    --xsltproc-opts='$(XSLT_ARGS)' $(COMMON_ARGS)

# most convenient deliverables
DOCS_OUT = mkimage-profiles.7 $(PROJECT).pdf $(PROJECT).html docbook-xsl.css

# intermediate files
DOCS_TMP = $(PROJECT).fo $(PROJECT).xml

.PHONY: all prep chunked xhtml pdf clean

all: man chunked xhtml pdf

# NB: destination defined externally
publish: all
	@if [ -n "$(DOCS_PUBLISH)" ]; then \
		rsync -qa $(DOCS_OUT) "$(DOCS_PUBLISH)"; \
	fi

prep:
	@if [ -n "$(BUILDDIR)" ]; then mkdir -p "$(BUILDDIR)"; fi

man:
	@VERSION="$$(cat ../VERSION)"; \
	sed -e "s,@VERSION@,$$VERSION,g" \
		< mkimage-profiles.7.in \
		> mkimage-profiles.7

chunked xhtml: prep
	@echo "** building $@ book"
	@$(A2X) -f $@ $(HTML_ARGS)

pdf: prep
	@echo "** building $@ book"
	@$(A2X) --xsltproc-opts='$(XSLT_ARGS) \
		--stringparam title.font.family "DejaVu Sans" \
		--stringparam body.font.family "DejaVu Serif" \
		--stringparam monospace.font.family "DejaVu Sans Mono"' \
		--fop --fop-opts='-c $(FXC)' -f pdf $(COMMON_ARGS)

clean:
	@echo "** cleaning up"
	@if [ -d "$(BUILDDIR)" ]; then cd "$(BUILDDIR)"; fi; \
	rm -rf $(DOCS_OUT) $(DOCS_TMP) $(PROJECT).chunked/
