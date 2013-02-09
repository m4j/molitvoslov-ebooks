TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../../)
HEADER=$(TOP)/header
IMG_TARGET_DIR=sites/default/files
ICON=molitvoslov-ebook

.PHONY: images images-vk clean

all: images images-vk

images-vk:
	make ICON=molitvoslov-vk-ebook images

images: $(IMG_TARGET_DIR) $(IMG_TARGET_DIR)/$(ICON)-pdf.png $(IMG_TARGET_DIR)/$(ICON)-epub.png $(IMG_TARGET_DIR)/$(ICON)-fb2.png

$(IMG_TARGET_DIR):
	mkdir -p $(IMG_TARGET_DIR)
	
$(IMG_TARGET_DIR)/$(ICON)-pdf.png: $(HEADER)/$(ICON).svg
	#
	# create directory structure and copy template
	convert $? \
	  -resize 65x65 \
	  -bordercolor gray85 -border 1 \
	  -gravity South -background Red -splice 0x18 -fill white -font Helvetica-Bold -annotate +0+2 'PDF' \
	  \( +clone -background black -shadow 80x3+5+5 \) +swap -background '#FDF1E0' -layers merge +repage \
	  $@

$(IMG_TARGET_DIR)/$(ICON)-epub.png: $(HEADER)/$(ICON).svg
	#
	# create directory structure and copy template
	convert $? \
	  -resize 65x65 \
	  -bordercolor gray85 -border 1 \
	  -gravity South -background '#85b916' -splice 0x18 -fill black -font Helvetica-Bold -annotate +0+2 'ePUB' \
	  \( +clone -background black -shadow 80x3+5+5 \) +swap -background '#FDF1E0' -layers merge +repage \
	  $@

$(IMG_TARGET_DIR)/$(ICON)-fb2.png: $(HEADER)/$(ICON).svg
	#
	# create directory structure and copy template
	convert $? \
	  -resize 65x65 \
	  -bordercolor gray85 -border 1 \
	  -gravity South -background '#f7931eff' -splice 0x18 -fill white -font Helvetica-Bold -annotate +0+2 'FB2' \
	  \( +clone -background black -shadow 80x3+5+5 \) +swap -background '#FDF1E0' -layers merge +repage \
	  $@
	  
clean:
	rm -rf $(IMG_TARGET_DIR)
	
