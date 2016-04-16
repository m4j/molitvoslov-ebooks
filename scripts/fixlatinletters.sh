#!/bin/bash

sed -i "" \
-e 's/\([а-я]\)a\([а-я]\)/\1а\2/g' \
-e 's/\([а-я]\)c\([а-я]\)/\1с\2/g' \
-e 's/\([а-я]\)e\([а-я]\)/\1е\2/g' \
-e 's/\([а-я]\)o\([а-я]\)/\1о\2/g' \
-e 's/\([а-я]\)p\([а-я]\)/\1р\2/g' \
-e 's/\([а-я]\)x\([а-я]\)/\1х\2/g' \
-e 's/\([а-я]\)y\([а-я]\)/\1у\2/g' $1
