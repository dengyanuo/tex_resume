#!/bin/bash

# https://www.biblegateway.com/passage/?search=1+peter+1&version=NIV

test -z "${bibleVsion}" && bibleVsion=NIV

test -z "$1" && target_name='1+peter' || target_name=$1

if [ -z "$2" ]; then
    if [ "${bibleVsion}" = "CUV" ] ; then
        nowEXT=xelatex
    else
        nowEXT=tex
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


rm -f 1.txt
wget \
    -q "https://www.biblegateway.com/passage/?search=${target_name}&version=${bibleVsion}" \
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
\\usepackage[AutoFakeBold,AutoFakeSlant]{xeCJK}
\\setCJKmainfont[BoldFont=simhei.ttf, SlantedFont=simkai.ttf]{simsun.ttc}
\\setCJKsansfont[AutoFakeSlant=false,
  BoldFont=simhei.ttf, SlantedFont=simkai.ttf]{simsun.ttc}
\\setCJKmonofont[ItalicFont=simkai.ttf]{simsun.ttc}
\\begin{document}
{ \\centering \
" > ${target_file}

cat 19_${bibleVsion}.txt  \
    >> ${target_file} 

cat   18_${bibleVsion}.txt \
    >> ${target_file} 

echo "

\end{document}
" >> ${target_file}
}


if [ "${bibleVsion}" = "CUV" ] ; then
    gen_XELATEX
else
    gen_TEX
fi



echo "`ls -l ${target_file} ` .... generated"
