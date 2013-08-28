
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

# Old compiler, does not seem to make much difference,
# compile time = ~1m48sec (2 sec slower than the new compiler).
# (Tested both 3 times.)
compile_old_comp:
	time gf +RTS -K100M -RTS --old-comp --make --path $(path) --preproc=mkPresent estonian/LangEst.gf

clean:
	find -name *.gfo | xargs rm -f
