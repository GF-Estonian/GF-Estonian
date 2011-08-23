Starting gf with non-standard stack size (e.g. 100MB) which is needed for languages like Finnish:

gf +RTS -K100M -RTS

M: heap, K: stack
see: http://www.haskell.org/ghc/docs/7.0.3/html/users_guide/runtime-control.html


Some performance information:

i3 4GB RAM; Ubuntu 11.04
gf 3.2
svn rev 14
gf +RTS -K100M -RTS
i LangEst.gf
reading + compiling + linking: 1305620 msec


Example of parsing a simple sentence:

Lang> p "naine on vanha"
PhrUtt NoPConj (UttS (UseCl (TTAnt TFut ASimul) PPos (PredVP (DetCN (DetQuant DefArt NumSg) (UseN woman_N)) (UseComp (CompAP (PositA old_A)))))) NoVoc
PhrUtt NoPConj (UttS (UseCl (TTAnt TFut ASimul) PPos (PredVP (DetCN (DetQuant IndefArt NumSg) (UseN woman_N)) (UseComp (CompAP (PositA old_A)))))) NoVoc
PhrUtt NoPConj (UttS (UseCl (TTAnt TFut ASimul) PPos (PredVP (MassNP (UseN woman_N)) (UseComp (CompAP (PositA old_A)))))) NoVoc
PhrUtt NoPConj (UttS (UseCl (TTAnt TPres ASimul) PPos (PredVP (DetCN (DetQuant DefArt NumSg) (UseN woman_N)) (UseComp (CompAP (PositA old_A)))))) NoVoc
PhrUtt NoPConj (UttS (UseCl (TTAnt TPres ASimul) PPos (PredVP (DetCN (DetQuant IndefArt NumSg) (UseN woman_N)) (UseComp (CompAP (PositA old_A)))))) NoVoc
PhrUtt NoPConj (UttS (UseCl (TTAnt TPres ASimul) PPos (PredVP (MassNP (UseN woman_N)) (UseComp (CompAP (PositA old_A)))))) NoVoc


Checking the morpho:

Lang> i -retain LexiconEst.gf

Lang> cc paris_PN
{s = table ResEst.Case ["Pariis"; "Pariiin"; "Pariista";
                        "Pariiinks"; "Pariiina"; "Pariiins"; "Pariiinst"; "Pariiiseen";
                        "Pariiinl"; "Pariiinlt"; "Pariiinle"; "Pariiinta"; "Pariiinga";
                        "Pariiinni"];
 lock_PN : {} = <>}
10 msec
Lang> cc now_Adv 
{s = "nyyd"; lock_Adv : {} = <>}
10 msec


------
EmbedVP is weird already in Finnish:
Lang> gr -tr MassNP (SentCN (UseN apple_N) (EmbedVP ?)) | l
MassNP (SentCN (UseN apple_N) (EmbedVP (ProgrVP (PassV2 close_V2))))

apple to be being closed
õun olla suljetaan


12 msec
Lang> gr -tr MassNP (SentCN (UseN apple_N) (EmbedVP ?)) | l
MassNP (SentCN (UseN apple_N) (EmbedVP (UseComp (CompAdv everywhere_Adv))))

apple to be everywhere
õun olla kaikkialla

