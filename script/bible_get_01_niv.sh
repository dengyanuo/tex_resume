#!/bin/bash

# https://www.biblegateway.com/passage/?search=1+peter+1&version=NIV

test -z "${bibleVsion}" && bibleVsion=NIV

test -z "$1" && target_name='1+peter' || target_name=$1

target_file=bible__${bibleVsion}_$(echo $target_name|sed -e 's;[+ -];_;g').tex

#echo " target_file         = ${target_file}"
#echo " target_name         = ${target_name}"

if [ -f "${target_file}" ] ; then
    echo
    echo " file (${target_file}) exit. skip."
    echo "`ls   -l ${target_file}` .... already exist."
    echo
    exit 
fi

cat > ${target_file}  << EOF0
\input ../header/example_tex01.tex
\FFrh \baselineskip = 14pt
\parskip 0.3 em


\centerline{  \FFbg
EOF0

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
    -e '1s,^.*Bible Gateway passage: *,,g' \
    -e '1s,"/>, }\n,g' \
    \
    \
    >> ${target_file} 

cat >> ${target_file}  << EOF2


\bye

EOF2

echo "`ls -l ${target_file} ` .... generated"
