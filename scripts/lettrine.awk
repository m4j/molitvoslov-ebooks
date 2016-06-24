BEGIN{ ln=0; par=0}
/mychapter{/ {ln=0; par=0; print "============="}
#/^[ \t]*$/ { ln=1; }
#/^[ \t]*$/ { if (ln == 0) {ln=1; printf "\n";} }
#ln == 0 {print $0; }
/^[^{%\\].+/ { 
    if (ln == 0) {
        par=1;
        ln=1;
        print "ln:"$0# | "sed 's/\(.\)\(.*\)/\\\textcolor{red}{\1}\2/'"
    }
}
{
    if (par == 0) {
        print $0;
    }
    par=0;
} 

