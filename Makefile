
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
	@echo "            > cc -table 'küberspionaaž_N'"
	@echo "            > cc -table valmis_A"
	@echo "            > cc -table abi_andma_V"
	@echo "            > cc -table kohe_Adv"
	@echo
	@echo "count_dict: show the frequency distribution of constructor patterns in DictEst"
	@echo
	@echo "  diff_rgl: compare the GF RGL version of Estonian with the current version"
	@echo "            (set GF_SRC to the root of the GF source distribution, it is currently '$(GF_SRC)')"
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

diff_rgl:
	diff $(GF_SRC)/lib/src/api/CombinatorsEst.gf api/CombinatorsEst.gf
	diff $(GF_SRC)/lib/src/api/ConstructorsEst.gf api/ConstructorsEst.gf
	diff $(GF_SRC)/lib/src/api/SyntaxEst.gf api/SyntaxEst.gf
	diff $(GF_SRC)/lib/src/api/SymbolicEst.gf api/SymbolicEst.gf
	diff $(GF_SRC)/lib/src/api/TryEst.gf api/TryEst.gf
	diff -r $(GF_SRC)/lib/src/estonian/ estonian

hjk_classes:
	cat data/nouns.6forms.csv | sed "s/,.*//" | python tools/cc.py -r estonian/HjkClassify.gf --oper hjk_type | gf --run

hjk_classes_freq:
	cat data/nouns.6forms.csv | sed "s/,.*//" | python tools/cc.py -r estonian/HjkClassify.gf --oper hjk_type | gf --run | sort | uniq -c | sort -nr

clean:
	find -name *.gfo | xargs rm -f
