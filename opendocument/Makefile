TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../)
TARGET=molitvoslov
HTLATEX=htlatex
TARGET_DIR=target
IMG_DIR=$(TOP)/img
XSLT_DIRPROC=xsltproc --nonet
XSLT_DIR=$(TOP)/xslt
XML_CATALOG_FILES=$(XSLT_DIR)/catalog/catalog.xml
SCRIPTS=$(TOP)/scripts
VERSION_FILE=$(TOP)/VERSION
VERSION=$(shell cat $(VERSION_FILE))
HTLATEX_CONFIG=custom.cfg
COVERS=$(TOP)/header
TARGET_VERSION=$(TARGET_DIR)/$(TARGET)-$(VERSION)
#UNICODE4HF=$(shell kpsewhich unicode.4hf)

# epub metadata
#include $(TARGET).mk

.PHONY: odt 

odt: $(TARGET_DIR) $(TARGET_VERSION).odt

$(TARGET_DIR):
	#
	# create directory structure and copy template
	mkdir -p $(TARGET_DIR)

#unicode.4hf: $(UNICODE4HF)
	# override unicode to html entities table
	# because character entities like &hellip; do not work well
	# for odt...
	#sed "s/^'\([&\#;[:alnum:]]*\)'.*$/'\1' '' '\1' ''/" $? >$@

myroot.tmp: $(TOP)/root.tex
	# override unicode to html entities table
	# because character entities like &hellip; do not work well
	# for odt...
	sed "s/\\include{/\\input{..\//" $? >$@

$(TARGET).odt: $(TOP)/*.tex $(HTLATEX_CONFIG) $(TARGET).tex myroot.tmp
	#
	# execute tex4ht process
	$(HTLATEX) $(TARGET).tex "$(HTLATEX_CONFIG)" "ooffice! -cmozhtf -utf8" "-coo -cvalidate"
	
$(TARGET_VERSION).odt: $(TARGET).odt
	cp $? $@

clean:
	rm -rf *~ *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.lof *.ptc* *.mtc* *.maf *.4ct *.4tc *.css *.html* *.idv *.lg *.odt *.tmp *.xref $(TARGET_DIR)

