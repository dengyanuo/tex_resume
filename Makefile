
clean_dst11:=*.log *.ps *.pdf *.dvi *.aux
clean_dst12:=$(foreach aa1,$(clean_dst11), */$(aa1))
clean_dst21:=$(wildcard $(clean_dst11) $(clean_dst12))

F1latex:=$(wildcard src*/*.latex)
F2tex:=$(wildcard src*/*.tex)
Fs:=$(F1latex) $(F2tex)

PDF1latex:=$(foreach aa1,$(basename $(notdir $(F1latex))),pdf/$(aa1).pdf)
PDF2tex:=$(foreach   aa1,$(basename $(notdir $(F2tex))),pdf/$(aa1).pdf)
PDFs:=$(PDF1latex) $(PDF2tex)


all: $(PDFs)
	# F1latex		$(F1latex)
	# F2tex			$(F2tex)
	# PDF1latex		$(PDF1latex)
	# PDF2tex		$(PDF2tex)
	@echo
	@ls -l pdf/*.pdf

#pdf/latex_002_article_1998.pdf:Makefile
pre1latex:=$(foreach aa1,$(F1latex),$$(eval $(aa1):pdf/$(aa1)))

define FUNCtex2pdf
$1 : $(wildcard src*/$(basename $(notdir $(1))).tex)
	@echo
	# $1 : $$^
	cd tmp/ && tex ../$$^ && dvipdf $$(notdir $$(basename $$^)).dvi ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738181 ; exit 21)

endef

define FUNClatex2pdf
$1 : $(wildcard src*/$(basename $(notdir $(1))).latex)
	@echo
	# $1 : $$^
	cd tmp/ && latex ../$$^ && dvipdf $$(notdir $$(basename $$^)).dvi ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738181 ; exit 21)

endef

$(foreach aa3,$(PDF1latex),$(eval $(call FUNClatex2pdf, $(aa3))))
$(foreach aa3,$(PDF2tex),$(eval   $(call FUNCtex2pdf,   $(aa3))))

c clean:

ca clean_all:
#	rm -f *.log *.ps *.pdf *.dvi *.aux
#	rm -f $(clean_dst11)
#	rm -f $(clean_dst12)
#	rm -f $(clean_dst21)
	$(if $(clean_dst21),rm -f $(clean_dst21))

m vim_makefile:
	vim Makefile

up push :
	@echo git push -u origin main
	git push 

gs:
	git status

ga:
	git add .

gc:
	git commit -a -m '$(shell date +%Y_%m%d_%H%M%P)'
