TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TARGET=molitvoslov
INCLUDEONLY=
LATEX=pdflatex
PDFTK=pdftk
TARGET_DIR=target
VERSION_FILE=VERSION
VERSION=$(shell cat $(VERSION_FILE))
SCRIPTS=$(TOP)/scripts

FETCH_RESOURCES=[["/o-molitve"], "/content/soderzhanie", ["/slovar.php"]]

ifdef ONLY
INCLUDEONLY=\includeonly{$(ONLY)}
endif

.PHONY: all fetch clean clean-rel pdf-to-rel pdf-vk-to-rel epub-to-rel epub-vk-to-rel fb2-to-rel fb2-vk-to-rel

fetch:
	fdir=import_`date '+%Y%m%d'`; \
	mkdir -p $$fdir/img && \
	cd $$fdir && $(SCRIPTS)/fetch.py 0 http://www.molitvoslov.org '$(FETCH_RESOURCES)'

ARGS = "\nonstopmode $(INCLUDEONLY) \input{$(TARGET)}"

all: clean-rel pdf-to-rel pdf-vk-to-rel epub-to-rel epub-vk-to-rel fb2-to-rel fb2-vk-to-rel

clean-rel:
	rm -rf rel/*

epub-to-rel:
	cd epub && make clean epub
	cp -av epub/$(TARGET_DIR)/*.epub rel/

epub-vk-to-rel:
	cd epub && make TARGET=molitvoslov-vk clean epub
	cp -av epub/$(TARGET_DIR)/*.epub rel/

fb2-to-rel:
	cd fb2 && make clean fb2
	cp -av fb2/$(TARGET_DIR)/*.fb2.zip rel/

fb2-vk-to-rel:
	cd fb2 && make TARGET=molitvoslov-vk clean fb2
	cp -av fb2/$(TARGET_DIR)/*.fb2.zip rel/

pdf-to-rel: clean pdf
	cp -av $(TARGET_DIR)/*.pdf rel/

pdf-vk-to-rel:
	make TARGET=molitvoslov-vk clean pdf
	cp -av $(TARGET_DIR)/*.pdf rel/

pdf: $(TARGET_DIR)/$(TARGET)-$(VERSION).pdf

$(TARGET_DIR)/header:
	mkdir -p $(TARGET_DIR)/header

$(TARGET_DIR)/header/%.pdf: header/%.pdf $(VERSION_FILE)
	# Edit title page pdf:
	# uncompress title page pdf and replace version string 0123456789 with
	# the contents of VERSION file and then recompress into target folder
	$(PDFTK) $< output - uncompress | sed "s/\[( 012345)3(6789)\]TJ/( $(VERSION))Tj/" | $(PDFTK) - output $@ compress

$(TARGET_DIR)/$(TARGET)-$(VERSION).pdf: *.tex img/* $(TARGET_DIR)/header $(TARGET_DIR)/header/$(TARGET)_a4.pdf uzory/*
	mkdir -p $(TARGET_DIR)
	$(LATEX) $(ARGS)
	#makeindex $(TARGET).idx
	#pdflatex $(TARGET).tex
	latex_count=5 ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' $(TARGET).log && [ $$latex_count -gt 0 ] ;\
		do \
		  echo "Rerunning latex...." ;\
		  $(LATEX) $(ARGS) ;\
		  latex_count=`expr $$latex_count - 1` ;\
		done
	mv $(TARGET).pdf $(TARGET_DIR)/$(TARGET)-$(VERSION).pdf

clean:
	rm -rf *~ *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.lof *.ptc* *.mtc* *.maf *.4ct *.4tc *.css *.html *.idv *.lg *.tmp *.xref $(TARGET_DIR)
