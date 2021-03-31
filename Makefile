
clean_dst11:=*.log *.ps *.dvi *.aux *.out *.toc
clean_dst21:=$(foreach aa1,$(clean_dst11), tmp/$(aa1)) tmp/*.pdf
clean_dst22:=$(foreach aa1,$(clean_dst11), */$(aa1))
clean_dst91:=$(wildcard $(clean_dst21) )
clean_dst92:=$(wildcard $(clean_dst22) )

F1latex:=$(wildcard src*/*.latex)
F2tex:=$(wildcard src*/*.tex bible*/*.tex)
F3xelatex:=$(wildcard xelatex*/*.xelatex bible*/*.xelatex src*/*.xelatex )
F7combine:=$(wildcard src*/*.combine)
F8books:=$(wildcard books/*.pdf)
Fs:=$(F1latex) $(F2tex)

PDF1latex:=$(foreach     aa1,$(basename $(notdir $(F1latex))),pdf/$(aa1).pdf)
PDF2tex:=$(foreach       aa1,$(basename $(notdir $(F2tex))),pdf/$(aa1).pdf)
PDF3xelatex:=$(foreach   aa1,$(basename $(notdir $(F3xelatex))),pdf/$(aa1).pdf)
PDF7combine:=$(foreach   aa1,$(basename $(notdir $(F7combine))),pdf/$(aa1).pdf)
PDF8books:=$(foreach     aa1,$(basename $(notdir $(F8books))),pdf/$(aa1).pdf)
PDFs:=$(PDF1latex) $(PDF2tex) $(PDF3xelatex) $(PDF8books) $(PDF7combine)
PDFs_out:=example_tex01.tex
PDFs:=$(filter-out $(PDFs_out),$(PDFs))


all: $(PDFs)
	@echo
	@ls -l pdf/*.pdf
	echo "$${index_html}" > pdf/index.html

#pdf/latex_002_article_1998.pdf:Makefile
pre1latex:=$(foreach aa1,$(F1latex),$$(eval $(aa1):pdf/$(aa1)))

# pdftk cv_02231010am_common_2021_dengyanuo_cover_letter.pdf rs_02181536pm_2021_dengyanuo_resume.pdf cat output b.pdf
# PDF7combine:=$(foreach   aa1,$(basename $(notdir $(F7combine))),pdf/$(aa1).pdf) FUNCbooks8pdf FUNCcombine7pdf,


define FUNCcombine7pdf
$1 : \
	$(wildcard src*/$(basename $(notdir $(1))).combine) \
	$(shell cat \
	$(wildcard src*/$(basename $(notdir $(1))).combine) \
	|sed \
		-e 's;^ *;;g' \
		-e '/^#/d' \
		-e '/^ *$$/d' \
		-e 's;^;pdf/;g' \
		)

	@echo
	# $1 : $$^ 
	pdftk \
		$$(wordlist 2,9,$$^) \
		cat output $1
	@ls -l $1 || (echo $1 not found. 1738188 ; exit 28)

endef

define FUNCbooks8pdf
$1 : $(wildcard books/$(basename $(notdir $(1))).pdf)
	@echo
	# $1 : $$^
	cp $$^ $1 
	@ls -l $1 || (echo $1 not found. 1738188 ; exit 28)

endef

define FUNCxelatex2pdf
$1 : $(wildcard \
	src*/$(basename $(notdir $(1))).xelatex \
	xelatex*/$(basename $(notdir $(1))).xelatex \
	bible*/$(basename $(notdir $(1))).xelatex \
	)
	@echo
	# $1 : $$^
	cd tmp/ && xelatex ../$$^ && mv     $$(notdir $$(basename $$^)).pdf ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738182 ; exit 22)

endef

define FUNCtex2pdf
$1 : $(wildcard \
	src*/$(basename $(notdir $(1))).tex \
	bible*/$(basename $(notdir $(1))).tex \
	)
	@echo
	# $1 : $$^
	#cd tmp/ &&  tex ../$$^ && dvipdf $$(notdir $$(basename $$^)).dvi ../pdf/$$(notdir $$(basename $$^)).pdf 
	cd tmp/ && xetex ../$$^ && mv     $$(notdir $$(basename $$^)).pdf ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738182 ; exit 22)

endef

define FUNClatex1pdf
$1 : $(wildcard src*/$(basename $(notdir $(1))).latex)
	@echo
	# $1 : $$^
	#cd tmp/ &&  latex ../$$^ && dvipdf $$(notdir $$(basename $$^)).dvi ../pdf/$$(notdir $$(basename $$^)).pdf 
	cd tmp/ && xelatex ../$$^ && mv     $$(notdir $$(basename $$^)).pdf ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738181 ; exit 21)

endef

$(foreach aa3,$(PDF1latex),$(eval       $(call FUNClatex1pdf, $(aa3))))
$(foreach aa3,$(PDF2tex),$(eval         $(call FUNCtex2pdf,   $(aa3))))
$(foreach aa3,$(PDF3xelatex),$(eval     $(call FUNCxelatex2pdf,   $(aa3))))
$(foreach aa3,$(PDF7combine),$(eval     $(call FUNCcombine7pdf, $(aa3))))
$(foreach aa3,$(PDF8books),$(eval       $(call FUNCbooks8pdf, $(aa3))))

c clean:
	$(if $(clean_dst91),rm -f $(clean_dst91))

ca clean_all:
	$(if $(clean_dst92),rm -f $(clean_dst92))

m vim_makefile:
	vim Makefile

gu up push :
	@echo git push -u origin master --force
	git push 

gd:
	git diff

gs:
	git status

ga:
	git add .

gc:
	git commit -a -m '$(shell date +%Y_%m%d_%H%M%P)'

X : ga gc up






pythonVersion3exist:=$(shell which python3)
ifeq (,$(pythonVersion3exist))
pythonVersion:=2
pyBin:=python2
else
pythonVersion:=3
pyBin:=python3
endif

pyHttp2:=SimpleHTTPServer
pyHttp3:=http.server
pyHttP:=$(pyHttp$(pythonVersion))
s2: server2
server2:
	[ -f docs/index.html ] || ( echo "why_no_51 file <docs/index.html> exist ?" ; exit 51 )
	cd docs/ && $(pyBin) -m $(pyHttP) 33221







index_html_idx:=1

define index_html
<html>
    <head>

        <meta http-equiv="content-type"    content="text/html; charset=utf-8" />

        <style>

table, th, td {
	margin-left: auto;
	margin-right: auto;
	padding: 10px;
    border: 1px solid black;
}
        </style>


    </head>
    <body onload="TTTmyTimer()">

        <table>
            <tr>
                <th>idx</th>
                <th>Name</th>
                <th>FileSize</th>
            </tr>
$(foreach aa1,$(sort $(PDFs)),$(if $(wildcard $(aa1)),
<tr>
<td> $(index_html_idx) </td>
<td> 
<a href="$(notdir $(aa1))" target="_blank" src="" referrerpolicy="no-referrer" ref="noreferrer"> $(notdir $(aa1))</a>
</td>
<td> $(shell cat $(aa1)|wc -c) </td>
</tr>
$(eval index_html_idx:=$(shell expr $(index_html_idx) + 1))
))
$(eval index_html_idx:=1)
        </table>

    </body>
</html>


endef
export index_html


bibleS_list:=\
	1+corinthians+15 \
	  Galatians+1 \
	  galatians+1 \
	  hebrews+11 \
	  john+20 \
	1+peter+1 \
	  philippians+4 \

NIV:=script/bible_get_01_niv.sh
CUV:=script/bible_get_01_cuv.sh
export NIVext:=tex
export NIVext:=xelatex
export CUVext:=xelatex

bb : bible_NIV bible_CUV

bv_list:=NIV CUV
b_delete_space:=CUV
# NIV : $(NIV)
# bible_NIV : NIV
$(foreach aa1,$(bv_list), $(eval $(aa1) : $($(aa1))))
$(foreach aa1,$(bv_list), $(eval bible_$(aa1) : $(aa1)))

#bible_NIV , bible_CUV : 
$(foreach aa1,$(bv_list), bible_$(aa1) ):
	cd bible01/ && \
		export bibleVsion=$< ; \
		$(if $(findstring $<,$(b_delete_space)), export b_delete_space=1; , export b_delete_space=0; )  \
		for aa1 in $(bibleS_list) ; do \
		aa3=$<ext; \
		aa2=`echo bible__$<_$${aa1}|sed -e 's;[+ -]\+;_;g'`.$${!aa3} ; \
		test -f $${aa2} && echo "`ls -l $${aa2}` ... alread exist8381." \
		|| ( ../${$<} $${aa1} $${aa2}) || exit 44 ; \
		done

font : font_list.txt font_zhcn.txt 
	ls -l $^
font_list.txt :
	fc-list  | cut -d\  -f2-99 | cut -d: -f1     \
		|sort -u > $@
font_zhcn.txt :
	fc-list :lang=zh-cn       \
		|sort -u > $@
