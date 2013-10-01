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
--    ConsAP xs x = consrTable2Adj comma xs x ;
--    BaseAP x y = twoTable2 Bool NForm x y ;
--    ConsAP xs x = consrTable2 Bool NForm comma xs x ;
    BaseRS x y = twoTable Agr x y ** {c = y.c} ;
    ConsRS xs x = consrTable Agr comma xs x ** {c = xs.c} ;

  lincat
    [S] = {s1,s2 : Str} ;
    [Adv] = {s1,s2 : Str} ;
    [NP] = {s1,s2 : NPForm => Str ; a : Agr} ;
    [AP] = {s1,s2 : AP} ; -- Bool => NForm => Str} ;
    [RS] = {s1,s2 : Agr => Str ; c : NPForm} ;
    
  oper
    --copypasted from prelude/Coordination.gf and modified
    twoTable2Adj : (_,_ : AP) -> {s1,s2 : AP} = \x,y ->
      {s1 = x ; s2 = y} ; 
      
    consrTable2Adj : Str -> {s1,s2 : AP} -> AP -> {s1,s2 : AP} = \c,xs,x ->
      let
        adj1 = xs.s1 ;
        adj2 = xs.s2 
      in 
      {s1 = lin AP {s = \\b,nf => adj1.s ! b ! nf ++ c ++ adj2.s ! b ! nf ;
                    infl = True ;
                    lock_AP = <> } ;
       s2 = x ** {lock_AP = <>}
      } ; 
    
    conjunctDistrTable2Adj : ConjunctionDistr -> {s1,s2 : AP} -> AP =  \or,xs ->
      let
        adj1 = xs.s1 ;
        adj2 = xs.s2 ;   
      in
      lin AP {s = \\b,nf =>
                case <adj1.infl, adj2.infl> of {
                   <False,False> => or.s1 ++ adj1.s ! b ! (NCase Sg Nom) ++ or.s2 ++ adj2.s ! b ! (NCase Sg Nom) ;
                   <False,True>  => or.s1 ++ adj1.s ! b ! (NCase Sg Nom) ++ or.s2 ++ adj2.s ! b ! nf ;
                   <True,False>  => or.s1 ++ adj1.s ! b ! nf ++ or.s2 ++ adj2.s ! b ! (NCase Sg Nom) ;
                   _ => or.s1 ++ adj1.s ! b ! nf ++ or.s2 ++ adj2.s ! b ! nf 
                } ;
              infl = True ;
              lock_AP = <> } ;
    

}
