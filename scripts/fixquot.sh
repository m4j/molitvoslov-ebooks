#!/bin/bash

#git checkout $1
sed -i 's/"---/\&mdash;/g' $1
sed -i 's/&quot;/"/g' $1
sed -i 's/"\([[:alnum:]\.,:;(){}&?[:space:]]\+\)"/«\1»/g' $1
sed -i 's/“/«/g' $1
sed -i 's/”/»/g' $1
grep -Hn '"' $1

sed -i 's/\&mdash;/"---/g' $1
sed -i 's/–/"---/g' $1
sed -i 's/—/"---/g' $1
sed -i 's/, "---/,"---/g' $1

sed -i 's/т\.е\./т.~е./g' $1
sed -i 's/т\.д\./т.~д./g' $1
sed -i 's/\.\.\./…/g' $1

#use ndash in number intervals
sed -i 's/\([0-9]\)-\([0-9]\)/\1--\2/g' $1

#fix some invisible unicode characters
sed -i 's/ //g' $1
sed -i 's/­//g' $1
