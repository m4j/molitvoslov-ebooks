#!/bin/bash
#
#       epubmkopf.sh
#
#       This script generates OPF according to EPUB 2.0 spec in a target
#       directory.
#       
#       Copyright 2011-2013 Max Agapov <m4j@swissmail.org>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

get_latex_field(){
    sed -n "s/\\\\$1{\(.*\)}/\1/p" $2
}

print_item() {
    [ -f "$2" ] && printf '    <item id="%s" href="%s" media-type="%s" />\n' "$1" "$2" "$3"
}

TARGET=$1
HTML_DIR=$2
SPINE_XSLT=$3

if [ -z "$TITLE" ]; then
    TITLE=`get_latex_field title $TARGET.tex`
fi
if [ -z "$CREATOR" ]; then
    CREATOR=`get_latex_field author $TARGET.tex`
fi
if [ -z "$DATE" ]; then
    DATE=`date "+%Y-%m-%d"`
fi

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="bookid" version="2.0">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
      <dc:title>$TITLE</dc:title>
      <dc:creator>$CREATOR</dc:creator>
      <dc:contributor opf:role="bkp">$CONTRIBUTOR_BKP</dc:contributor>
      <dc:publisher>$PUBLISHER</dc:publisher>
      <dc:format>$FORMAT</dc:format>
      <dc:date>$DATE</dc:date>
      <dc:subject>$SUBJECT</dc:subject>
      <dc:description>$DESCRIPTION</dc:description>
      <dc:rights>$RIGHTS</dc:rights>
      <dc:identifier id="bookid">$BOOK_ID</dc:identifier>
      <dc:language>$BOOK_LANG</dc:language>
      <meta name="cover" content="cover-image"/>
  </metadata>
  <manifest>
    <item id="pt" href="page-template.xpgt" media-type="application/vnd.adobe-page-template+xml"/>
    <item id="style" href="$TARGET.css" media-type="text/css" />
    <item id="cover" href="cover.html" media-type="application/xhtml+xml" />
    <item id="cover-image" href="cover.jpg" media-type="image/jpg" />
    <!-- item id="cover-vect" href="cover.svg" media-type="image/svg+xml" / -->
    <item id="cover-thumb" href="thumb.jpg" media-type="image/jpg" />
    <item id="toc" href="$TARGET.html" media-type="application/xhtml+xml" />
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml" />
EOF

( cd $HTML_DIR

  # counter for item ids
  ID=1

  # output fonts
  for file in fonts/*ttf; do
      print_item "item-$((ID++))" "$file" "application/x-font-ttf"
  done

  # output font licenses
  for file in fonts/*txt; do
      print_item "item-$((ID++))" "$file" "text/plain"
  done

  # output images
  for file in `find images -type f -name "*.png"`; do
      print_item "item-$((ID++))" "$file" "image/png"
  done

  for file in `find images -type f -name "*.svg"`; do
      print_item "item-$((ID++))" "$file" "image/svg+xml"
  done

  # match both 'jpg' and 'jpeg'
  for file in `find images -type f -name "*.jp*g"`; do
      print_item "item-$((ID++))" "$file" "image/jpeg"
  done

)

# output chapters
for file in ${TARGET}???*\.html; do
    print_item "$file" "$file" "application/xhtml+xml"
done

cat <<EOF
  </manifest>
  <spine toc="ncx">
    <itemref idref="cover" linear="no"/>
    <itemref idref="toc" />
EOF

# output itemrefs
xsltproc --nonet "$SPINE_XSLT" "$TARGET.html" || exit

cat <<EOF

  </spine>
  <guide>
    <reference type="toc" title="Оглавление" href="$TARGET.html" />
    <reference type="cover" title="Cover" href="cover.html"/>
  </guide>
</package>
EOF
