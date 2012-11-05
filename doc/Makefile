# build asciidoc books

ifdef BUILDDIR
DEST = -D "$(BUILDDIR)"
endif

ifdef DEBUG
VERBOSE = --verbose
endif

PROJECT = mkimage-profiles
TOPLEVEL_DOC = $(PROJECT).asciidoc
RESOURCE_FILES = /etc/asciidoc

A2X = a2x
FXC = .fop.xconf

L = ru
DEPTH = 3

# common args (and the source file to process) come last
XSLT_ARGS = --stringparam toc.max.depth $(DEPTH)
COMMON_ARGS = -d book -a lang="$L" $(DEST) $(VERBOSE) $(TOPLEVEL_DOC)
HTML_ARGS = -a data-uri --icons -r $(RESOURCE_FILES) -r . \
	    --xsltproc-opts='$(XSLT_ARGS)' $(COMMON_ARGS)

.PHONY: all prep chunked xhtml pdf clean

all: chunked xhtml pdf

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
	rm -f $(PROJECT).pdf $(PROJECT).html docbook-xsl.css; \
	rm -rf $(PROJECT).chunked/
