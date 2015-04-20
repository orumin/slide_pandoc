TEX=xelatex
PANDOC=pandoc

SRC=src
TARGET=slides
TARGETDIR=raster

THEME=Copenhagen

all: $(SRC).md
	$(PANDOC) -t beamer -V theme:$(THEME) -o $(TARGET).pdf $(SRC).md -H add-preamble.tex --latex-engine=xelatex --slide-level 2 --toc -N

clean:
	rm -rf $(TARGET).pdf $(TARGETDIR)

preview: all
	xdg-open $(TARGET).pdf

rasterize: clean all
	impressive -o $(TARGETDIR) -g 1366x768 $(TARGET).pdf

presentation: rasterize
	impressive --transition Crossfade --transtime 50 -q -c memory $(TARGETDIR)
