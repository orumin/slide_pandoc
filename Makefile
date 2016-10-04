TEX=xelatex
BIBTEX=pbibtex
PANDOC=pandoc
PDFNUP=pdfnup

SLIDE=slide.pdf
HANDOUT=handout.pdf

COUNT=3

SRC=src.md
TEXFILE=$(SRC:.md=.tex)
#TEMPLATE=sty/my.beamer
#BIBFILES=cite/paper.bib
#BIBSTYLES=sty/elsevier-vancouver.csl
#REFSTYLES=sty/crossref_config.yaml

#you can suggest fontsize below: 8pt, 9pt, 10pt, 11pt, 12pt, 14pt, 17pt, 20pt
FONTSIZE=11pt
#THEME=Copenhagen
THEME=CambridgeUS

PANDOC_FLAGS  = -t beamer -V fontsize:$(FONTSIZE) -V theme:$(THEME) -H add-preamble.tex --slide-level 2 --toc -N
#PANDOC_FLAGS  = -t beamer -V fontsize:$(FONTSIZE) -V theme:$(THEME) -H add-preamble.tex --template=$(TEMPLATE) --slide-level 1
#PANDOC_FLAGS += --filter pandoc-crossref --filter pandoc-citeproc
#PANDOC_FILTER_FLAGS= --bibliography=$(BIBFILES) --csl=$(BIBSTYLES)

HANDOUT_FLAGS = --nup 2x3 --no-landscape --keepinfo --paper A4 --frame true --scale 0.9 --suffix "nup"

.SUFFIXES: .tex .md .pdf
.PHONY: all semi-clean clean $(HANDOUT)

all: $(SLIDE) semi-clean

.md.tex:
	$(PANDOC) $^ $(PANDOC_FLAGS) $(PANDOC_FILTER_FLAGS) -o $(TEXFILE)

$(SLIDE): $(TEXFILE)
	@for i in `seq 1 $(COUNT)`; \
	do \
		$(TEX) -interaction=batchmode $(TEXFILE); \
		if [ ! -e "$(TEXFILE:.tex=.bbl)" ]; then \
			$(BIBTEX) $(basename $(TEXFILE)); \
		fi \
	done
	@mv $(TEXFILE:.tex=.pdf) $(SLIDE)

$(HANDOUT): $(SLIDE)
	$(PDFNUP) $(HANDOUT_FLAGS) $^
	mv slide-nup.pdf $@

clean: semi-clean
	@rm -rf $(SLIDE) $(HANDOUT)

semi-clean:
	@rm -f *.aux *.log *.nav *.out *.lof *.toc *.bbl *.blg *.xml *.bcf *blx.bib *.spl *.snm

preview: $(SLIDE)
	xdg-open $(SLIDE)
