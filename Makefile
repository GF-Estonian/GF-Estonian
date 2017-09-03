
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

diff_rgl:
	diff $(GF_SRC)/lib/src/api/CombinatorsEst.gf api/CombinatorsEst.gf
	diff $(GF_SRC)/lib/src/api/ConstructorsEst.gf api/ConstructorsEst.gf
	diff $(GF_SRC)/lib/src/api/SyntaxEst.gf api/SyntaxEst.gf
	diff $(GF_SRC)/lib/src/api/SymbolicEst.gf api/SymbolicEst.gf
	diff $(GF_SRC)/lib/src/api/TryEst.gf api/TryEst.gf
	diff -r $(GF_SRC)/lib/src/estonian/ estonian

# Show latest changes to Estonian in the GF repository
changes_rgl:
	cd $(GF_SRC)
	git log --name-status -15 -- lib/src/estonian/

hjk_classes:
	cat data/nouns.6forms.csv | sed "s/,.*//" | python tools/cc.py -r estonian/HjkClassify.gf --oper hjk_type | gf --run

hjk_classes_freq:
	cat data/nouns.6forms.csv | sed "s/,.*//" | python tools/cc.py -r estonian/HjkClassify.gf --oper hjk_type | gf --run | sort | uniq -c | sort -nr

clean:
	find -name *.gfo | xargs rm -f
