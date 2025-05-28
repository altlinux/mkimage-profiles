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
DOCS_OUT = $(PROJECT).pdf $(PROJECT).html docbook-xsl.css

# files for publish
DOCS_FOR_PUBLISH = $(DOCS_OUT) mkimage-profiles.chunked mkimage-profiles.7

# intermediate files
DOCS_TMP = $(PROJECT).fo $(PROJECT).xml

.PHONY: all prep chunked xhtml pdf clean

all: chunked xhtml pdf

# NB: destination defined externally
publish:
	@if [ -n "$(DOCS_PUBLISH)" ]; then \
		rsync -qa $(DOCS_FOR_PUBLISH) "$(DOCS_PUBLISH)"; \
	fi

prep:
	@if [ -n "$(BUILDDIR)" ]; then mkdir -p "$(BUILDDIR)"; fi

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
