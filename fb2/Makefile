TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../)
TARGET=molitvoslov
HTLATEX=htlatex
TARGET_DIR=target
IMG_DIR=$(TOP)/img
XSLT_DIRPROC=xsltproc --nonet
XSLT_DIR=$(TOP)/xslt
XML_CATALOG_FILES=$(XSLT_DIR)/catalog/catalog.xml
SCRIPTS=$(TOP)/scripts
FB2XSD=xsd/FictionBook2.1.xsd
IMAGE_PREFIX=img_
VERSION_FILE=$(TOP)/VERSION
VERSION=$(shell cat $(VERSION_FILE))
ALL_IMAGES=$(shell find $(IMG_DIR) -iname "*.jp*g")
HTLATEX_CONFIG=custom.cfg
COVERS=$(TOP)/header
TARGET_FB2=$(TARGET_DIR)/$(TARGET)-$(VERSION).fb2
#IMG_SIGN_OPTS="-gravity south -background white -fill grey65 -splice 0x20 -font Helvetica-Bold -pointsize 13 -annotate +0+2 'Изображение с портала www.molitvoslov.org'"
IMG_SIGN_OPTS=""
#UNICODE4HF=$(shell kpsewhich unicode.4hf)

# epub metadata
include $(TARGET).mk

.PHONY: fb2 fb2check img

fb2: $(TARGET_DIR) img $(TARGET_FB2).zip

$(TARGET_DIR):
	#
	# create directory structure and copy template
	mkdir -p $(TARGET_DIR)

#unicode.4hf: $(UNICODE4HF)
	# override unicode to html entities table
	# because character entities like &hellip; do not work well
	# for fb2...
	#sed "s/^'\([&\#;[:alnum:]]*\)'.*$/'\1' '' '\1' ''/" $? >$@

myroot.tmp: $(TOP)/root.tex
	# override unicode to html entities table
	# because character entities like &hellip; do not work well
	# for fb2...
	sed "s/\\include{/\\input{..\//" $? >$@

$(TARGET).html: $(TOP)/*.tex $(HTLATEX_CONFIG) $(TARGET).tex unicode.4hf myroot.tmp
	#
	# execute tex4ht process
	$(HTLATEX) $(TARGET).tex "$(HTLATEX_CONFIG)" " -cunihtf -utf8" ""
	
$(TARGET_DIR)/cover.jpg: $(COVERS)/$(TARGET)-ebook.svg
	#
	# copy cover file
	convert $? $@
	
$(TARGET).html.0: $(TARGET).html $(TARGET_DIR)/cover.jpg
	cp -v $(TARGET).html $@
	# append cover image
	$(SCRIPTS)/fbcnvimg.sh "$(TARGET_DIR)" "$(IMAGE_PREFIX)" cover >>$@
	# append all other images used in the document,
	# sorting and filtering out duplicates
	sed -n 's/^.*<image xlink:href="#$(IMAGE_PREFIX)\(.*\)".*$$/\1/p' $(TARGET).html | sort -u | xargs --verbose	$(SCRIPTS)/fbcnvimg.sh "$(TARGET_DIR)" "$(IMAGE_PREFIX)" >>$@
	echo '</FictionBook>' >> $@

$(TARGET_FB2): $(TARGET).html.0
	#
	# call xsl transformation for finishing touch-ups
	export LC_TIME=ru_RU.UTF-8; \
	export FB2_DATE="`date "+%e %B %Y"`"; \
	export FB2_DATEVALUE="`date "+%Y-%m-%d"`"; \
	$(XSLT_DIRPROC) \
		--stringparam document-info-version "$(VERSION)" \
		--stringparam document-info-date "$$FB2_DATE" \
		--stringparam document-info-date-value "$$FB2_DATEVALUE" \
		--stringparam cover-image-id "$(IMAGE_PREFIX)cover" \
		--stringparam title-info-title "$(TITLE)" \
		--stringparam document-info-id "$(BOOK_ID)" \
		$(XSLT_DIR)/fb2.xslt $? >$@

$(TARGET_FB2).zip: $(TARGET_FB2)
	#
	# package fb2.zip
	zip -X9Dqj $@ $? && unzip -l $@
	
fb2check:
	xmllint --noout --schema $(FB2XSD) $(TARGET_FB2)

$(TARGET_DIR)/*.jpg: $(ALL_IMAGES)
	for file in $?; do \
		fname=`basename $$file`; \
		sign_opts=$(IMG_SIGN_OPTS); \
		if ! expr "$$file" : ".*/wide/.*"; then \
			sign_opts="-rotate '90' $$sign_opts -rotate '-90'"; \
		fi; \
		cnv="convert $$file -resize 333x333 -density 72 -quality 65 $$sign_opts $(@D)/$${fname%.*}.jpg"; \
		echo $$cnv; sh -c "$$cnv"; \
	done

img: $(TARGET_DIR) $(TARGET_DIR)/*.jpg

clean:
	rm -rf *~ *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.lof *.ptc* *.mtc* *.maf *.4ct *.4tc *.css *.html* *.idv *.lg *.tmp *.xref $(TARGET_DIR)

