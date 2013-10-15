
path=present:estonian


all: help

help:
	@echo "Some commands for testing the grammar:"
	@echo
	@echo "  pgf_lang: compile estonian/LangEst.gf (that uses the small demo lexicon)"
	@echo
	@echo " pgf_lang1: compile other/Lang1Est.gf (that uses the large lexicon DictEst)"
	@echo
	@echo "       try: open the grammar as resource (to use 'cc')"
	@echo "            e.g."
	@echo "            > cc -one mkS negativePol (mkCl (mkNP this_Quant (mkN \"värv\")) (mkA \"tume\"))"
	@echo "            see värv ei ole tume"
	@echo
	@echo " load_dict: load DictEst (to use 'cc')"
	@echo "            e.g."
	@echo "            > cc -table koer_N"
	@echo
	@echo "count_dict: show the frequency distribution of constructor patterns in DictEst"
	@echo
	@echo "     clean: remove gfo-files"

# -v: verbose (gives some idea of what slows down the linking)
pgf_lang:
	time gf +RTS -K100M -RTS --make --path $(path) --preproc=mkPresent estonian/LangEst.gf

pgf_lang1:
	time gf +RTS -K50M -RTS --make --path $(path) other/Lang1Est.gf

try:
	gf --path=api:estonian --retain api/TryEst.gf

run_lang1:
	gf +RTS -K50M -RTS Lang1.pgf

load_dict:
	gf +RTS -K50M -RTS --retain estonian/DictEst.gf

count_dict:
	cat estonian/DictEst.gf | grep " = mk" | wc -l
	cat estonian/DictEst.gf | grep " = mk" | sed "s/.*= //" | sed 's/"[^"]*"//g' | sed "s/  */ /g" | sed "s/;//" | sort | uniq -c | sort -nr

clean:
	find -name *.gfo | xargs rm -f
