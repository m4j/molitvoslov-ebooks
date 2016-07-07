BASEDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TOP=$(BASEDIR)/..
TARGET=molitvoslov
TARGET_TOC=$(TARGET)li2
TARGET_PREFACE=$(TARGET)li1
TARGET_COVER=cover
INCLUDEONLY=
TARGET_DIR=target
VERSION_FILE=$(TOP)/VERSION
VERSION=$(shell cat $(VERSION_FILE))
SCRIPTS=$(TOP)/scripts
IMG=$(TOP)/img
ORNAMENTS=$(TOP)/uzory
COVERS=$(TOP)/header

# epub-related variables
HTLATEX_CONFIG=custom/custom.cfg
EPUB_CSS=custom/custom.css
EPUB_COLOR_CSS=custom/color.css
EPUB_TEMPLATE=template
TARGET_EPUB_DIR=$(TARGET_DIR)/epub
PACKAGED_EPUB=$(TARGET_EPUB_DIR).epub
TARGET_IMG_DIR=$(TARGET_DIR)/img
EPUB_HTML_DIR=$(TARGET_EPUB_DIR)/OEBPS
EPUB_META_DIR=$(TARGET_EPUB_DIR)/META-INF
EPUB_NAV=nav.xhtml
EPUB_NCX=nav.ncx
EPUB_OPF=content.opf
TARGET_EPUB=$(BASEDIR)/$(TARGET_DIR)/$(TARGET)-$(VERSION).epub
TARGET_MOBI=$(BASEDIR)/$(TARGET_DIR)/$(TARGET)-$(VERSION).mobi
#IMG_SIGN_OPTS="-gravity south -background white -fill grey65 -splice 0x26 -font Helvetica-Bold -pointsize 19 -annotate +0+2 'Изображение с портала www.molitvoslov.org'"
IMG_SIGN_OPTS=
EPUB_ORNAMENTS = $(EPUB_HTML_DIR)/images/uzor_begin_10.png $(EPUB_HTML_DIR)/images/uzor_begin_4.png $(EPUB_HTML_DIR)/images/uzor_begin_9.png $(EPUB_HTML_DIR)/images/uzor_end_3.png $(EPUB_HTML_DIR)/images/uzor_end_red.png $(EPUB_HTML_DIR)/images/uzor_psaltyr.png $(EPUB_HTML_DIR)/images/krest.png $(EPUB_HTML_DIR)/images/dove-kinovar.png

# external programs and converters
LATEX=htlatex
KINDLEGEN=kindlegen
JAVA=java
EPUBCHECK_JAR=$(wildcard epubcheck/epubcheck*jar)
XSLTPROC=xsltproc --nonet
XSLT=$(TOP)/xslt
XML_CATALOG_FILES=$(XSLT)/catalog/catalog.xml
UNAME=$(shell uname)
ifeq ($(UNAME), Linux)
    SED_INPLACE=sed -i
endif
ifeq ($(UNAME), Darwin)
    SED_INPLACE=sed -i ''
endif

# epub metadata
include $(TARGET).mk

.PHONY: all epub mobi eps images 

ARGS = "\nonstopmode $(INCLUDEONLY) \input{$(TARGET)}"

all: clean mobi

epub: eps images $(TARGET_EPUB)

mobi: epub $(TARGET_MOBI)

eps: $(TARGET_EPUB_DIR) $(TARGET_IMG_DIR)/tall/images $(TARGET_IMG_DIR)/wide/images $(TARGET_IMG_DIR)/images

#images: $(TARGET_EPUB_DIR) $(EPUB_HTML_DIR)/images/*.png $(EPUB_HTML_DIR)/cover.svg $(EPUB_HTML_DIR)/cover.png $(EPUB_HTML_DIR)/thumb.jpg
images: $(TARGET_EPUB_DIR) $(EPUB_ORNAMENTS) $(EPUB_HTML_DIR)/cover.jpg $(EPUB_HTML_DIR)/cover.svg

$(TARGET_EPUB_DIR):
	#
	# create directory structure and copy template
	mkdir -p $(TARGET_EPUB_DIR)
	cp -vr $(EPUB_TEMPLATE)/* $(TARGET_EPUB_DIR)/
	mkdir -p $(EPUB_HTML_DIR)/images
	mkdir -p $(TARGET_IMG_DIR)/tall
	mkdir -p $(TARGET_IMG_DIR)/wide

$(TARGET_IMG_DIR)/images: $(IMG)/*.jp*g $(ORNAMENTS)/*.pdf
	for file in $?; do \
		fname=`basename $$file`; \
		cp -v $$file $(@D)/$${fname%.*}.jpg; \
		convert $$file $(@D)/$${fname%.*}.eps; \
	done
	touch $(@D)/images

$(TARGET_IMG_DIR)/tall/images: $(IMG)/tall/*.jp*g
	for file in $?; do \
		fname=`basename $$file`; \
		cp -v $$file $(@D)/$${fname%.*}.jpg; \
		convert $$file $(@D)/$${fname%.*}.eps; \
	done
	touch $(@D)/images

$(TARGET_IMG_DIR)/wide/images: $(IMG)/wide/*.jp*g
	for file in $?; do \
		fname=`basename $$file`; \
		cp -v $$file $(@D)/$${fname%.*}.jpg; \
		convert $$file $(@D)/$${fname%.*}.eps; \
	done
	touch $(@D)/images



$(EPUB_HTML_DIR)/images/%.png: $(ORNAMENTS)/%.png
	cp -av "$<" "$@"

$(EPUB_HTML_DIR)/images/%.png: $(ORNAMENTS)/%.pdf
	resize_to="600x600"; \
	if expr "$<" : ".*end"; then \
		resize_to="250x250"; \
	fi; \
	convert $< -depth 8 -quality 10 -resize $${resize_to} $@

myroot.tmp: $(TOP)/root.tex
	# override unicode to html entities table
	# because character entities like &hellip; do not work well
	# for fb2...
	sed "s/\\include{/\\input{..\//" $? >$@

$(TARGET).html: *.tex $(HTLATEX_CONFIG) $(TARGET).tex myroot.tmp
	#
	# execute tex4ht process
	$(LATEX) $(TARGET).tex "$(HTLATEX_CONFIG)" " -cunihtf -utf8" "" && \
	$(SED_INPLACE)  -e "s;\.html;.xhtml;" $(TARGET)*.html

$(EPUB_HTML_DIR)/$(EPUB_NAV): $(TARGET_TOC).html
	export XML_CATALOG_FILES=$(XML_CATALOG_FILES); \
	$(XSLTPROC) \
		--stringparam xml_lang "$(BOOK_LANG)" \
        --stringparam stylesheet "$(TARGET).css" \
		--stringparam dtb_uid "$(TARGET)-$(VERSION)" \
		--stringparam docTitle "$(TITLE)" \
		--stringparam docAuthor "$(CREATOR)" \
		--stringparam docTOCLabel "Оглавление" \
		--stringparam docCoverLabel "Обложка" \
		--stringparam docCoverPage "$(TARGET_COVER).xhtml" \
		--stringparam docPrefaceLabel "Предисловие" \
		--stringparam docPrefacePage "$(TARGET_PREFACE).xhtml" \
		-o "$@" $(XSLT)/epubmknav.xslt "$<"

$(EPUB_HTML_DIR)/$(EPUB_NCX): $(TARGET_TOC).html 
	export XML_CATALOG_FILES=$(XML_CATALOG_FILES); \
	$(XSLTPROC) \
		--stringparam xml_lang "$(BOOK_LANG)" \
		--stringparam dtb_uid "$(TARGET)-$(VERSION)" \
		--stringparam docTitle "$(TITLE)" \
		--stringparam docAuthor "$(CREATOR)" \
		-o "$@" $(XSLT)/epubmkncx.xslt "$<"

$(EPUB_HTML_DIR)/$(EPUB_OPF): $(TARGET).html
	export XML_CATALOG_FILES=$(XML_CATALOG_FILES); \
	export BOOK_ID="$(TARGET)-$(VERSION)"; \
	export CREATOR="$(CREATOR)"; \
	export PUBLISHER="$(PUBLISHER)"; \
	export RIGHTS="$(RIGHTS)"; \
	export TITLE="$(TITLE)"; \
	export SUBTITLE="$(SUBTITLE)"; \
	export EXT_TITLE="$(EXT_TITLE)"; \
	export BOOK_LANG="$(BOOK_LANG)"; \
	export EPUB_NAV="$(EPUB_NAV)"; \
	export EPUB_NCX="$(EPUB_NCX)"; \
	$(SCRIPTS)/epubapplyxslt.sh $(TARGET) $(EPUB_HTML_DIR) $(XSLT)/epubxpgt.xslt && \
	$(SED_INPLACE)  \
		-e "s;$(TARGET_IMG_DIR)/wide;images;" \
		-e "s;$(TARGET_IMG_DIR)/tall;images;" \
		-e "s;$(TARGET_IMG_DIR);images;" \
		$(EPUB_HTML_DIR)/$(TARGET)*.xhtml && \
	export img_fnames="`sed -n 's;^.*<img src="images/\([-_\.[:alnum:]]*\)".*$$;\1;p' $(EPUB_HTML_DIR)/$(TARGET)*.xhtml | sort -u`"; \
    echo $$img_fnames; \
	for file in $$img_fnames; do \
		fname=`find $(TARGET_IMG_DIR) -name $$file`; \
		sign_opts=$(IMG_SIGN_OPTS); \
		if ! expr "$$fname" : ".*/wide/.*"; then \
			sign_opts="-rotate '90' $$sign_opts -rotate '-90'"; \
		fi; \
		cnv="convert $$fname -density 72 -quality 75 -resize 500x500 $$sign_opts $(@D)/images/`basename $$fname`"; \
		echo $$cnv; sh -c "$$cnv"; \
	done; \
	$(SCRIPTS)/epubmkopf.sh $(TARGET) $(EPUB_HTML_DIR) $(XSLT)/epubmkspine.xslt $(TARGET_TOC).html > "$@"

	
$(EPUB_HTML_DIR)/color.css: $(EPUB_COLOR_CSS)
	cp -v $? $@

$(EPUB_HTML_DIR)/$(TARGET).css: $(EPUB_CSS)
	cp -v $? $@

$(EPUB_HTML_DIR)/cover.jpg: $(COVERS)/$(TARGET)-ebook-tabloid.svg
	convert $? -adaptive-resize "600x730^" -quality 95 $@
	
$(EPUB_HTML_DIR)/cover.svg: $(COVERS)/$(TARGET)-ebook-tabloid.svg
	cp -v $? $@
	
package: $(EPUB_HTML_DIR)/$(EPUB_OPF) $(EPUB_HTML_DIR)/$(TARGET).css $(EPUB_HTML_DIR)/color.css $(EPUB_HTML_DIR)/$(EPUB_NAV) $(EPUB_HTML_DIR)/$(EPUB_NCX) 
	cd $(TARGET_EPUB_DIR); \
	  zip -0Xq $(PACKAGED_EPUB) mimetype; \
	  zip -Xr9Dq $(PACKAGED_EPUB) META-INF OEBPS

$(PACKAGED_EPUB): $(EPUB_HTML_DIR)/$(EPUB_OPF) $(EPUB_HTML_DIR)/$(TARGET).css $(EPUB_HTML_DIR)/color.css $(EPUB_HTML_DIR)/$(EPUB_NAV) $(EPUB_HTML_DIR)/$(EPUB_NCX) 
	$(JAVA) -jar $(EPUBCHECK_JAR) $(TARGET_EPUB_DIR) -mode exp -save

$(TARGET_EPUB): $(PACKAGED_EPUB)
	cp -v $? $@ && unzip -l $@

$(TARGET_MOBI): $(TARGET_EPUB)
	$(KINDLEGEN) -dont_append_source $?

clean:
	rm -rf *~ *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.lof *.ptc* *.mtc* *.maf *.4ct *.4tc *.css *.html *.idv *.lg *.tmp *.xref $(TARGET_DIR)
