concrete ConjunctionEst of Conjunction = 
  CatEst ** open ResEst, Coordination, Prelude in {

  flags optimize=all_subs ;

  lin

    ConjS = conjunctDistrSS ;

    ConjAdv = conjunctDistrSS ;

    ConjNP conj ss = conjunctDistrTable NPForm conj ss ** {
      a = conjAgr (Ag conj.n P3) ss.a ; -- P3 is the maximum
      isPron = False
      } ;

--    ConjAP conj ss = conjunctDistrTable2 Bool NForm conj ss ** {
    ConjAP conj ss = conjunctDistrTable2Adj conj ss ** {
      infl = True 
      } ;

    ConjRS conj ss = conjunctDistrTable Agr conj ss ** {
      c = ss.c
      } ;

-- These fun's are generated from the list cat's.

    BaseS = twoSS ;
    ConsS = consrSS comma ;
    BaseAdv = twoSS ;
    ConsAdv = consrSS comma ;
    BaseNP x y = twoTable NPForm x y ** {a = conjAgr x.a y.a} ;
    ConsNP xs x = consrTable NPForm comma xs x ** {a = conjAgr xs.a x.a} ;
    BaseAP x y = twoTable2Adj x y ;
    ConsAP xs x = consrTable2Adj comma x xs ; --xs x ;
--    BaseAP x y = twoTable2 Bool NForm x y ;
--    ConsAP xs x = consrTable2 Bool NForm comma xs x ;
    BaseRS x y = twoTable Agr x y ** {c = y.c} ;
    ConsRS xs x = consrTable Agr comma xs x ** {c = xs.c} ;

  lincat
    [S] = {s1,s2 : Str} ;
    [Adv] = {s1,s2 : Str} ;
    [NP] = {s1,s2 : NPForm => Str ; a : Agr} ;
    [AP] = {s1,s2 : {s : Bool => NForm => Str ; infl : Bool }} ; 
    [RS] = {s1,s2 : Agr => Str ; c : NPForm} ;
    
  oper
    --copypasted from prelude/Coordination.gf and modified
    twoTable2Adj : (_,_ : AP) -> [AP] = \x,y ->
    lin ListAP {
      s1 = x ; --** {lock_AP = <>} ;
      s2 = y --** {lock_AP = <>}
    } ; 
    
{-    consrTable2Adj : Str -> AP -> [AP] -> [AP] = \c,x,xs ->
    consrTable2Adj : Str -> [AP] -> {s : Bool => NForm => Str ; infl : Bool} -> [AP] = \c,xs,x ->
    let
      ap1 : AP = xs.s1 ; --  ** {lock_AP = <>} ;
      ap2 : AP = xs.s2 ; --** {lock_AP = <>}
      --x   : AP = x ** {lock_AP = <>}
    in lin ListAP
     {s1 = 
	     {s = \\b,nf =>
                case <x.infl, ap1.infl> of {
                   <False,False> => x.s ! b ! (NCase Sg Nom) ++ c ++ ap1.s ! b ! (NCase Sg Nom) ;
                   <False,True>  => x.s ! b ! (NCase Sg Nom) ++ c ++ ap1.s ! b ! nf ;
                   <True,False>  => x.s ! b ! nf ++ c ++ ap1.s ! b ! (NCase Sg Nom) ;
                   _ => x.s ! b ! nf ++ c ++ ap1.s ! b ! nf 
                } ;
	      infl = True 
	      --lock_AP = <> 
	      } ;

--table P {p => table Q {q => x.s ! p ! q ++ c ++ xs.s1 ! p ! q}} ; 
      s2 = ap2
     } ;   
-}
    consrTable2Adj : Str -> [AP] -> {s : Bool => NForm => Str ; infl : Bool} -> [AP] = \c,xs,x ->
      let
        ap1 = xs.s1 ; --  ** {lock_AP = <>} ;
        ap2 = xs.s2  --** {lock_AP = <>}
      in 
       lin ListAP {s1 = {s = \\b,nf =>
                case <ap1.infl, ap2.infl> of {
                   <False,False> => ap1.s ! b ! (NCase Sg Nom) ++ c ++ ap2.s ! b ! (NCase Sg Nom) ;
                   <False,True>  => ap1.s ! b ! (NCase Sg Nom) ++ c ++ ap2.s ! b ! nf ;
                   <True,False>  => ap1.s ! b ! nf ++ c ++ ap2.s ! b ! (NCase Sg Nom) ;
                   _ => ap1.s ! b ! nf ++ c ++ ap2.s ! b ! nf 
                } ;
              infl = True ;
              lock_AP = <> } ;
       s2 = x --** {lock_AP = <>}
      } ; 

    
    conjunctDistrTable2Adj : ConjunctionDistr -> [AP] -> AP =  \or,xs ->
      let
        ap1 = xs.s1 ;
        ap2 = xs.s2 ;   
      in
      lin AP {s = \\b,nf =>
                case <ap1.infl, ap2.infl> of {
                   <False,False> => or.s1 ++ ap1.s ! b ! (NCase Sg Nom) ++ or.s2 ++ ap2.s ! b ! (NCase Sg Nom) ;
                   <False,True>  => or.s1 ++ ap1.s ! b ! (NCase Sg Nom) ++ or.s2 ++ ap2.s ! b ! nf ;
                   <True,False>  => or.s1 ++ ap1.s ! b ! nf ++ or.s2 ++ ap2.s ! b ! (NCase Sg Nom) ;
                   _ => or.s1 ++ ap1.s ! b ! nf ++ or.s2 ++ ap2.s ! b ! nf 
                } ;
              infl = True ;
              lock_AP = <> } ;
    

}
