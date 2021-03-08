#!/bin/bash

# https://www.biblegateway.com/passage/?search=1+peter+1&version=NIV

version=NIV

test -z "$1" && target_name='1+peter' || target_name=$1

target_file=bible__$(echo $target_name|sed -e 's;[+ -];_;g').tex

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

\centerline{  \FFbg
EOF0

wget \
    -q "https://www.biblegateway.com/passage/?search=${target_name}&version=${version}" \
    -O - \
    |egrep 'std-text|og:title' \
    |sed \
    -e 's,&nbsp;, ,g' \
    \
    -e 's,> *<,>\n<,g' \
    -e 's,<a\b[^>]*>[^<]*</a>,\n,g' \
    \
    -e 's,<span\b[^>]*>,<span>,g' \
    -e 's,<sup\b[^>]*>,<sup>,g' \
    \
    -e 's,)</sup>, ,g' \
    -e 's,]</sup>, ,g' \
    -e 's,<sup>(, ,g' \
    -e 's,<sup>\[, ,g' \
    \
    -e 's,<sup>, ,g' \
    -e 's,</sup>, ,g' \
    -e 's,<span>, ,g' \
    -e 's,</span>, ,g' \
    \
    -e 's,<div\b[^>]*>, ,g' \
    -e 's,</div>, ,g' \
    \
    -e 's,<p\b[^>]*>,\n\\par ,g' \
    -e 's,</p>, ,g' \
    \
    -e 's,<h[0-9]>, {\\par ,g' \
    -e 's,</h[0-9]>, } ,g' \
    \
    -e 's,<br[ \/]*>, ,g' \
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
