#!/bin/bash
#
#       epubapplyxslt.sh
#
#       Performs XSL transformation on all HTML files that match pattern
#       in the current directory. Target pattern, target directory and
#       XSLT are supplied as arguments.
#       
#       Copyright 2011 Maxim Agapov <m4j@swissmail.org>
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
    sed -n "s/\\\\$1{\(.*\)}/\1/p" "$2"
}

TARGET=$1
HTML_DIR=$2
XSLT=$3

if [ -z "$TITLE" ]; then
    TITLE=`get_latex_field title $TARGET.tex`
fi
if [ -z "$AUTHOR" ]; then
    AUTHOR=`get_latex_field author $TARGET.tex`
fi
if [ -z "$DATE" ]; then
    DATE=`get_latex_field date $TARGET.tex`
fi

# transform all matching html files in the directory
for file in $TARGET??*.html; do
    outfile=${file%.*}.xhtml
    printf 'Transforming %s to %s...' "$file" "$outfile"
    xsltproc --nonet -o "$HTML_DIR/$outfile" "$XSLT" "$file"
    rc=$?
    if [ $rc -ne 0 ]; then
        # if something went wrong, restore previous order
        printf 'failed with error code %s\n' $rc
        exit $rc
    fi
    printf 'done\n'
done
