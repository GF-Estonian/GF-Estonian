
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

pgf_lang1:
	time gf +RTS -K50M -RTS --make --path $(path) other/Lang1Est.gf

run_lang1:
	gf +RTS -K50M -RTS Lang1.pgf

count_dict:
	cat estonian/DictEstAbs.gf | grep " : " | sed "s/.*: //" | sed "s/;//" | sort | uniq -c | sort -nr

clean:
	find -name *.gfo | xargs rm -f
