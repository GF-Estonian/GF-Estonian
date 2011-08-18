--1 Verb Phrases in Finnish

concrete VerbFin of Verb = CatFin ** open Prelude, ResFin in {

  flags optimize=all_subs ;

  lin
    UseV = predV ;

    SlashV2a v = predV v ** {c2 = v.c2} ;

    Slash2V3 v np = 
      insertObj 
        (\\fin,b,_ => appCompl fin b v.c2 np) (predV v) ** {c2 = v.c3} ;
    Slash3V3 v np = 
      insertObj 
        (\\fin,b,_ => appCompl fin b v.c3 np) (predV v) ** {c2 = v.c2} ;

    ComplVV v vp = 
      insertObj 
        (\\_,b,a => infVP v.sc b a vp v.vi) 
        (predV {s = v.s ; 
                sc = case vp.sc of {
                  NPCase Nom => v.sc ;   -- minun t�ytyy pest� auto
                  c => c                 -- minulla t�ytyy olla auto
                  } ;
                qp = v.qp
               }
         ) ;

    ComplVS v s  = insertExtrapos (etta_Conj ++ s.s) (predV v) ;
    ComplVQ v q  = insertExtrapos (          q.s) (predV v) ;
    ComplVA v ap = 
      insertObj 
        (\\_,b,agr => 
           let n = (complNumAgr agr) in
           ap.s ! False ! (NCase n (npform2case n v.c2.c))) --- v.cs.s ignored
        (predV v) ;

    SlashV2S v s = 
      insertExtrapos (etta_Conj ++ s.s) (predV v) ** {c2 = v.c2} ;
    SlashV2Q v q = 
      insertExtrapos (q.s) (predV v) ** {c2 = v.c2} ;
    SlashV2V v vp = 
      insertObj (\\_,b,a => infVP v.sc b a vp v.vi) (predV v) ** {c2 = v.c2} ;
      ---- different infinitives
    SlashV2A v ap = 
      insertObj 
        (\\fin,b,_ => 
          ap.s ! False ! (NCase Sg (npform2case Sg v.c3.c))) ----agr to obj
        (predV v) ** {c2 = v.c2} ;

    ComplSlash vp np = insertObjPre (\\fin,b,_ => appCompl fin b vp.c2 np) vp ;

    UseComp comp = 
      insertObj (\\_,_ => comp.s) (predV (verbOlla ** {sc = NPCase Nom ; qp = True})) ;

    SlashVV v vp = 
      insertObj 
        (\\_,b,a => infVP v.sc b a vp v.vi) 
        (predV {s = v.s ; 
                sc = case vp.sc of {
                  NPCase Nom => v.sc ;   -- minun t�ytyy pest� auto
                  c => c                 -- minulla t�ytyy olla auto
                  } ;
                qp = v.qp
               }
         ) ** {c2 = vp.c2} ; ---- correct ??

    SlashV2VNP v np vp = 
      insertObjPre 
        (\\fin,b,a => appCompl True b v.c2 np ++ ---- fin -> stack overflow
                      infVP v.sc b a vp v.vi) 
          (predV v) ** {c2 = vp.c2} ;

    AdvVP vp adv = insertAdv (\\_ => adv.s) vp ;

    AdVVP adv vp = insertAdv (\\_ => adv.s) vp ;

    ReflVP v = insertObjPre (\\fin,b,agr => appCompl fin b v.c2 (reflPron agr)) v ;

    PassV2 v = let vp = predV v in {
      s = \\_ => vp.s ! VIPass ;
      s2 = \\_,_,_ => [] ;
      adv = \\_ => [] ;
      ext = [] ;
      qp = v.qp ;
      sc = v.c2.c  -- minut valitaan ; minua rakastetaan ; minulle kuiskataan 
      } ;          ---- talon valitaan: should be marked like inf.

----b    UseVS, UseVQ = \v -> v ** {c2 = {s = [] ; c = NPAcc ; isPre = True}} ;

    CompAP ap = {
      s = \\agr => 
          let
            n = complNumAgr agr ;
            c = case n of {
              Sg => Nom ;  -- min� olen iso ; te olette iso
              Pl => Part   -- me olemme isoja ; te olette isoja
              }            --- definiteness of NP ?
          in ap.s ! False ! (NCase n c)
      } ;
    CompCN cn = {
      s = \\agr => 
          let
            n = complNumAgr agr ;
            c = case n of {
              Sg => Nom ;  -- min� olen iso ; te olette iso
              Pl => Part   -- me olemme isoja ; te olette isoja
              }            --- definiteness of NP ?
          in cn.s ! (NCase n c)
      } ;
    CompNP np = {s = \\_ => np.s ! NPCase Nom} ;
    CompAdv a = {s = \\_ => a.s} ;

}


--2 The object case
--
-- The rules involved are ComplV2 and ComplVV above.
-- The work is done jointly in ResFin.infVP and appCompl. 
-- Cases to test: l -table (to see negated forms)
--```
--   minun t�ytyy ostaa auto
--   PredVP (UsePron i_Pron) (ComplVV must_VV 
--     (ComplV2 buy_V2 (DetCN (DetSg (SgQuant DefArt) NoOrd) (UseN car_N))))
--   min� tahdon ostaa auton
--   PredVP (UsePron i_Pron) (ComplVV want_VV 
--     (ComplV2 buy_V2 (DetCN (DetSg (SgQuant DefArt) NoOrd) (UseN car_N))))
--   minulla t�ytyy olla auto
--   PredVP (UsePron i_Pron) (ComplVV must_VV 
--     (ComplV2 have_V2 (DetCN (DetSg (SgQuant DefArt) NoOrd) (UseN car_N))))
--```
-- Unfortunately, there is no nice way to say "I want to have a car".
-- (Other than the paraphrases "I want a car" or "I want to own a car".)
