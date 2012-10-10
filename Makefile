
path=present:estonian


all: help

help:
	@echo Targets:
	@echo
	@echo "compile:  compile estonian/LangEst.gf"
	@echo "  clean:  remove gfo-files"

# -v: verbose (gives some idea of what slows down the linking)
compile:
	gf +RTS -K100M -RTS --path $(path) --preproc=mkPresent estonian/LangEst.gf

clean:
	find -name *.gfo | xargs rm
