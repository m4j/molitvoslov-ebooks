#!/bin/bash

# we do not use \n in the substitute pattern of sed expression
# because it is not supported on BSD systems, such as Mac OS X

sed -E -n -i -e '
# if the first line copy the pattern to the hold buffer
1h
# if not the first line then append the pattern to the hold buffer
# and append newline
1!H
# if the last line then ...
$ {
        # copy from the hold to the pattern buffer
        g
        # do the search and replace
        s/\\bfseries Смотреть весь раздел &rarr;\\normalfont\{\}//g
        # print
        p
}' "$1"
