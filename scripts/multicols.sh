#!/bin/bash

IN=$1

cp "$IN" "$IN~" && sed \
  -e 's/mychapterending\[.*\]/mychapterending/' \
  -e 's/^\(.\+\)\\mychapterending/\1\n\n\\mychapterending/' \
  -e 's/\\longpage{}//' \
  -e 's/\\newpage//' \
  -e 's/myfig{/myfigure{/' \
  -e 's/myfig\[\(.*\)\]{/myfigure{/' \
  -e 's/myfigr{/myfigure{/' \
  -e 's/myfigr\[\(.*\)\]{/myfigure{/' \
  -e 's/myfigh{\(.*\)}{.*}/myfigure{\1}/' \
  -e 's/myfigh\[.*\]{\(.*\)}{.*}/myfigure{\1}/' \
  -e 's/\\normalfont{//g' \
  -e 's/\\itshape/\\myemph{/g' \
  -e 's/^\\section\[\(.*\)\].*/\\section{\1}/' "$IN~" |
    awk -f ins-multicols.awk > "$IN"

