#!/usr/bin/awk

BEGIN {
    # are we at mychapter beginning?
    chapter = "false"
}
/^\\mychapter{/ {chapter = "true"}
/^\\section{/ {
    if (chapter == "false") {
        printf("\\end{mymulticols}\n\n")
    }
    printf("%s\\begin{mymulticols}\n", $0)
    chapter = "false"
    next
}
/^\\mychapterending/ {
    printf("\n\\end{mymulticols}\n\n%s\n\n", $0);
    next
}
{print $0}

