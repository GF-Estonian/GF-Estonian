Estonian grammar in the Grammatical Framework
=============================================

Estonian resource grammar for the GF Resource Grammar Library.

Plan
----

### First changes

- lexicon from Fin to Est
- Paradigms in MorphoFin to Estonian paradigms. We should find out whether 10 forms is 
the worst-case scenario in Estonian too.
- MorphoEst implements the paradigms, assuming that 10 forms are given. ParadigmsEst does 
the magic from 1-4 forms to 10 forms.
- Syntax
- ???


Random notes
------------

### Starting GF with non-standard stack size

(e.g. 100MB) which is needed for languages like Finnish:

	gf +RTS -K100M -RTS

M: heap, K: stack
see: http://www.haskell.org/ghc/docs/7.0.3/html/users_guide/runtime-control.html


### Some performance information

	i3 4GB RAM; Ubuntu 11.04; gf 3.3; svn rev 14:
	$ cd estonian/
	$ gf +RTS -K100M -RTS
	$ i LangEst.gf
	reading + compiling + linking: 1312520 msec
	(i.e. 22 minutes)


### Checking the morpho

	Lang> i -retain LexiconEst.gf

	Lang> cc paris_PN
	{s = table ResEst.Case ["Pariis"; "Pariiin"; "Pariista";
                        "Pariiinks"; "Pariiina"; "Pariiins"; "Pariiinst"; "Pariiiseen";
                        "Pariiinl"; "Pariiinlt"; "Pariiinle"; "Pariiinta"; "Pariiinga";
                        "Pariiinni"];
	lock_PN : {} = <>}

	Lang> cc now_Adv 
	{s = "nyyd"; lock_Adv : {} = <>}


### EmbedVP is weird already in Finnish

	Lang> gr -tr MassNP (SentCN (UseN apple_N) (EmbedVP ?)) | l
	MassNP (SentCN (UseN apple_N) (EmbedVP (ProgrVP (PassV2 close_V2))))

	apple to be being closed
	õun olla suljetaan


	Lang> gr -tr MassNP (SentCN (UseN apple_N) (EmbedVP ?)) | l
	MassNP (SentCN (UseN apple_N) (EmbedVP (UseComp (CompAdv everywhere_Adv))))

	apple to be everywhere
	õun olla kaikkialla
