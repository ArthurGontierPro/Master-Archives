%SRCTEX=$(wildcard *.tex)

MAIN=rapport

all: $(MAIN).pdf 

$(MAIN).pdf: $(MAIN).tex 
	rubber --pdf $(MAIN)



clean:
	rm -f *.o *.aux *.log *.out *.bbl *.toc *.pdf *.blg *.dvi *~ *.fls *_latexmk *.spl *.ilg *.ind *.idx
