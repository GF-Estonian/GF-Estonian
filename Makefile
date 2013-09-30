
path=present:estonian


all: help

help:
	@echo Targets:
	@echo
	@echo "compile:  compile estonian/LangEst.gf"
	@echo "  clean:  remove gfo-files"

# -v: verbose (gives some idea of what slows down the linking)
compile:
	time gf +RTS -K100M -RTS --make --path $(path) --preproc=mkPresent estonian/LangEst.gf

try:
	gf --path=api:estonian --retain api/TryEst.gf

clean:
	find -name *.gfo | xargs rm -f
