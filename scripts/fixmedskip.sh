#!/bin/bash

sed -n -i '
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
        s/\\medskip\n*/\\medskip/g
        # print
        p
}' $1
