#!/bin/bash
#
#       epubmkopf.sh
#
#       This script generates OPF according to EPUB 3.0 spec in a target
#       directory.
#       
#       Copyright 2011-2016 Maxim Agapov <m4j@swissmail.org>
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

JOBNAME=$1
HTML_DIR=$2
SPINE_XSLT=$3
TOC=$4

if [ -z "$TITLE" ]; then
    TITLE=`get_latex_field title $JOBNAME.tex`
fi
if [ -n "$CREATOR" ]; then
    CREATOR="<dc:creator>$CREATOR</dc:creator>"
fi
if [ -z "$DATE" ]; then
    DATE=`date "+%Y-%m-%d"`
fi
if [ -z "$MOD_TIMESTAMP" ]; then
    MOD_TIMESTAMP=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
fi
if [ -n "$SUBTITLE" ]; then
    SUBTITLE="<dc:title id=\"subTitle\">$SUBTITLE</dc:title><meta refines=\"#subTitle\" property=\"title-type\">subtitle</meta>"
fi
if [ -n "$EXT_TITLE" ]; then
    EXT_TITLE="<dc:title id=\"extTitle\">$EXT_TITLE</dc:title><meta refines=\"#extTitle\" property=\"title-type\">extended</meta>"
fi

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="bookid" version="3.0" xml:lang="ru" dir="ltr">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
      $CREATOR
      <dc:title id="mainTitle">$TITLE</dc:title>
      <meta refines="#mainTitle" property="title-type">main</meta>
      $SUBTITLE
      $EXT_TITLE
      <dc:publisher>$PUBLISHER</dc:publisher>
      <dc:date>$DATE</dc:date>
      <dc:identifier id="bookid">$BOOK_ID</dc:identifier>
      <dc:language>$BOOK_LANG</dc:language>
      <meta name="cover" content="cover-image"/>
      <meta property="dcterms:modified">$MOD_TIMESTAMP</meta>
  </metadata>
  <manifest>
    <item id="pt" href="page-template.xpgt" media-type="application/vnd.adobe-page-template+xml"/>
    <item id="style" href="$JOBNAME.css" media-type="text/css" />
    <item id="cover" href="cover.xhtml" media-type="application/xhtml+xml" />
    <item id="cover-image" href="cover.jpg" media-type="image/jpeg" properties="cover-image"/>
    <!-- item id="cover-vect" href="cover.svg" media-type="image/svg+xml" / -->
    <item id="cover-thumb" href="thumb.jpg" media-type="image/jpeg" />
    <item id="ncx" href="$EPUB_NCX" media-type="application/x-dtbncx+xml" />
    <item id="navdoc" href="$EPUB_NAV" media-type="application/xhtml+xml" properties="nav"/>
EOF

( cd $HTML_DIR

  # counter for item ids
  ID=1

  # output fonts
  for file in fonts/*woff; do
      print_item "item-$((ID++))" "$file" "application/font-woff"
  done

  # output fonts
  for file in fonts/*otf; do
      print_item "item-$((ID++))" "$file" "application/font-sfnt"
  done

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

  # output chapters
  for file in ${JOBNAME}???*\.xhtml; do
      id=${file%.*}
      print_item "$id" "$file" "application/xhtml+xml"
  done

)

cat <<EOF
  </manifest>
  <spine toc="ncx">
    <itemref idref="cover"/>
EOF

( cd $HTML_DIR
  for file in ${JOBNAME}li?*\.xhtml; do
      id=${file%.*}
      printf '    <itemref idref="%s"/>\n' "$id"
  done
)

# output itemrefs
xsltproc --nonet "$SPINE_XSLT" "$TOC" || exit

cat <<EOF

  </spine>
</package>
EOF
