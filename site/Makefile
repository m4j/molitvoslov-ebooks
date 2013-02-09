TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../)
TARGET=molitvoslov
HTLATEX=htlatex
TARGET_DIR=target
TARGET_IMG_DIR=$(TARGET_DIR)/img
XSLTPROC=xsltproc --nonet
XSLT_DIR=$(TOP)/xslt
XML_CATALOG_FILES=$(XSLT_DIR)/catalog/catalog.xml
SCRIPTS=$(TOP)/scripts

.PHONY: site

site: $(TARGET_DIR) $(TARGET_DIR)/$(TARGET)*.html

$(TARGET_DIR):
	#
	# create directory structure and copy template
	mkdir -p $(TARGET_DIR)

$(TARGET)*.html: $(TOP)/*.tex $(TARGET).cfg $(TARGET).tex
	#
	# execute tex4ht process
	$(HTLATEX) $(TARGET).tex "$(TARGET)" " -cunihtf -utf8" ""

$(TARGET_DIR)/$(TARGET)*.html: $(TARGET)*.html
	export XML_CATALOG_FILES=$(XML_CATALOG_FILES); \
	for file in $?; do \
	  $(XSLTPROC) $(XSLT_DIR)/site.xslt $$file >$(TARGET_DIR)/$$file; \
	done
#		tidy -w -q -ashtml -utf8 $$file | \
#			sed 's;<a name="[-_\.[:alnum:]]*" id="[-_\.[:alnum:]]*"></a>;;' >$(TARGET_DIR)/$$file; \

clean:
	rm -rf *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.lof *.ptc* *.mtc* *.maf *.4ct *.4tc *.css *.html *.idv *.lg *.tmp *.xref $(TARGET_DIR)/$(TARGET)*
