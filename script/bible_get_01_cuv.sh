#!/bin/bash

# https://www.biblegateway.com/passage/?search=1+peter+1&version=NIV

test -z "${bibleVsion}" && bibleVsion=NIV

test -z "$1" && target_name='1+peter' || target_name=$1

if [ -z "$2" ]; then
    if [ "${bibleVsion}" = "CUV" ] ; then
        nowEXT=xelatex
    else
        nowEXT=tex
        nowEXT=xelatex
    fi
    target_file=bible__${bibleVsion}_$(echo $target_name|sed -e 's;[+ -];_;g').${nowEXT}
else
    target_file=$2
fi

#echo " target_file         = ${target_file}"
#echo " target_name         = ${target_name}"

if [ -f "${target_file}" ] ; then
    echo
    echo " file (${target_file}) exit. skip."
    echo "`ls   -l ${target_file}` .... already exist."
    echo
    exit 
fi

down_url="https://www.biblegateway.com/passage/?search=${target_name}&version=${bibleVsion}"

rm -f 1.txt
wget \
    -q "${down_url}" \
    -O - > 11_${bibleVsion}.txt

cat        11_${bibleVsion}.txt \
    |sed \
    -e 's,&nbsp;, ,g' \
    -e 's,> *<,>\n<,g' \
    > 12_${bibleVsion}.txt

cat   12_${bibleVsion}.txt \
    |sed \
    -e '1,/passage-content passage-class-0/ d' \
    -e '/passage-scroller/,$ d' \
    -e '/\"footnotes\"/,$ d' \
    |sed \
    -e 's,^ *,,g' \
    -e 's, *$,,g' \
    > 13_${bibleVsion}.txt

cat   13_${bibleVsion}.txt \
    |sed \
    -e 's,<a\b[^>]*>[^<]*</a>,\n,g' \
    -e 's,<span\b[^>]*>,<span>,g' \
    -e 's,<sup\b[^>]*>,<sup>,g' \
    -e 's,<p\b[^>]*>,<p>,g' \
    -e 's,<div\b[^>]*>,<div>,g' \
    > 14_${bibleVsion}.txt 

cat   14_${bibleVsion}.txt \
    |sed \
    -e 's;<;\n<;g' \
    -e 's,^ *,,g' \
    -e 's, *$,,g' \
    |sed \
    -e 's,<p\b[^>]*>, \\par ,g' \
    -e 's,<br\b[^>]*>, \\par ,g' \
    -e 's,<h[0-9]>, \\par ,g' \
    |sed \
    -e '/^$/ d' \
    -e '/^<div>$/ d' \
    -e '/^<sup>$/ d' \
    -e '/^<span>$/ d' \
    \
    -e '/^<\/sup>$/d' \
    -e '/^<\/span>$/d' \
    -e '/^<\/p>$/d' \
    -e '/^<\/div>$/d' \
    -e '/^<\/h[0-9]>$/d' \
    > 15_${bibleVsion}.txt 

cat   15_${bibleVsion}.txt \
    |sed \
    -e 's,^<span>,,g' \
    -e 's,^<sup>,,g' \
    -e 's,^</span>,,g' \
    -e 's,^</sup>,,g' \
    |sed \
    -e '/^($/ d' \
    -e '/^)$/ d' \
    -e '/^\[$/ d' \
    -e '/^\]$/ d' \
    \
    > 16_${bibleVsion}.txt 

if [ "${b_delete_space}" = "1" ] ; then
    cat   16_${bibleVsion}.txt \
        |sed -e 's, *,,g' \
        > 17_${bibleVsion}.txt 
        else
            cat   16_${bibleVsion}.txt \
                > 17_${bibleVsion}.txt 
fi

cat   17_${bibleVsion}.txt \
    \
    | sed \
    -e 's,^ *,,g' \
    -e 's, *$,,g' \
    -e '/^$/d' \
    \
    > 18_${bibleVsion}.txt 

cat   12_${bibleVsion}.txt \
    |grep og:title \
    |head -n 1 \
    |sed \
    -e '1s,^.*Bible Gateway passage: *,,g' \
    -e '1s,"/>, }\n,g' \
    > 19_${bibleVsion}.txt 





gen_TEX() {
echo "
\input ../header/example_tex01.tex
\FFrh \baselineskip = 13pt
\parskip 0.3 em


\centerline{  \FFbg\
" > ${target_file}

cat 19_${bibleVsion}.txt  \
    >> ${target_file} 

cat   18_${bibleVsion}.txt \
    >> ${target_file} 

echo "


\bye
" >> ${target_file}
}

gen_XELATEX() {
echo "
\\documentclass{article}
% https://www.overleaf.com/learn/latex/page_size_and_margins : portrait/landscape
\\usepackage[ letterpaper, margin=0.4in, portrait ]{geometry}
\\usepackage[AutoFakeBold,AutoFakeSlant]{xeCJK}
\\setCJKmainfont[BoldFont=simhei.ttf, SlantedFont=simkai.ttf]{simsun.ttc}
\\setCJKsansfont[AutoFakeSlant=false,
  BoldFont=simhei.ttf, SlantedFont=simkai.ttf]{simsun.ttc}
\\setCJKmonofont[ItalicFont=simkai.ttf]{simsun.ttc}
\\usepackage{multicol}
\\usepackage{color}
\\setlength{\\columnseprule}{2pt}
\\def\\columnseprulecolor{\\color{red}}
\\begin{document}
% set font size : https://www.programmersought.com/article/1714865085/
% \\large
% \\fontsize{9}{11} \\selectfont
% \\fontsize{10}{12} \\selectfont
% \\fontsize{11}{13} \\selectfont
% \\fontsize{12}{14} \\selectfont
% \\fontsize{13}{15} \\selectfont
% \\fontsize{14}{16} \\selectfont
% \\fontsize{15}{17} \\selectfont
\\fontsize{16}{18} \\selectfont
% \\fontsize{17}{19} \\selectfont
% \\fontsize{18}{20} \\selectfont
% \\fontsize{19}{21} \\selectfont
% \\fontsize{20}{22} \\selectfont
% use \pagenumbering{gobble} to switch off page numbering.
% To switch it on afterwards, use \pagenumbering{arabic} for arabic numbers 
% or alph, Alph, roman, or Roman for lowercase resp. uppercase alphabetic resp. Roman numbering.
% \thispagestyle{empty} \pagestyle{empty}
\\pagenumbering{gobble}
\\begin{multicols}{3}

{ \\centering \
" > ${target_file}

cat 19_${bibleVsion}.txt  \
    >> ${target_file} 

cat   18_${bibleVsion}.txt \
    >> ${target_file} 

echo "

\end{multicols}
\end{document}
" >> ${target_file}

echo "% down_url : ${down_url}" >> ${target_file}

}
# end of gen_XELATEX


if [ "${bibleVsion}" = "CUV" ] ; then
    gen_XELATEX
else
    # gen_TEX
    gen_XELATEX
fi



echo "`ls -l ${target_file} ` .... generated"
