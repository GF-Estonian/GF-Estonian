concrete NounEst of Noun = CatEst ** open ResEst, MorphoEst, Prelude in {

  flags optimize=all_subs ; coding=utf8;

  lin

-- The $Number$ is subtle: "nuo autot", "nuo kolme autoa" are both plural
-- for verb agreement, but the noun form is singular in the latter.

    DetCN det cn = 
      let
        n : Number = case det.isNum of {
          True => Sg ;
          _ => det.n
          } ;
        ncase : NPForm -> Case * NForm = \c ->
          let k = npform2case n c 
          in 
          case <n, c, det.isNum, det.isDef> of {
            <_, NPAcc,      True,_>  => <Nom,NCase Sg Part> ; -- kolme kytkintä
            <_, NPCase Nom, True,_>  => <Nom,NCase Sg Part> ; -- kolme kytkintä
            
            --Estonian special cases, only the last word gets case ending.
            --TODO same for adjectives
            <_, NPCase Comit, _, _>  => <Gen,NCase n Comit> ; --kolme kassiga
            <_, NPCase Abess, _, _>  => <Gen,NCase n Abess> ; --kolme kassita
            <_, NPCase Ess, _,  _>   => <Gen,NCase n Ess> ; --kolme kassina
            <_, NPCase Termin,_, _>  => <Gen,NCase n Termin> ; --kolme kassini
            
            <_, _, True,_>        => <k,  NCase Sg k> ;    -- kolmeksi kytkimeksi

            <Pl,NPCase Nom,  _,False> => <k,  NCase Pl Part> ; -- kytkimiä

            _                           => <k,  NCase n k>       -- kytkin, kytkimen,...
            }
      in {
      s = \\c => let 
                   k = ncase c ;
                 in
                 det.s ! k.p1 ++ cn.s ! k.p2 ;  --fin autoni, est no poss.suf.
      a = agrP3 (case det.isDef of {
            False => Sg ;  -- autoja menee; kolme autoa menee
            _ => det.n
            }) ;
      isPron = False
      } ;

    DetNP det = 
      let
        n : Number = case det.isNum of {
          True => Sg ;
          _ => det.n
          } ;
      in {
        s = \\c => let k = npform2case n c in
                 det.sp ! k ; -- det.s2 is possessive suffix 
        a = agrP3 (case det.isDef of {
            False => Sg ;  -- autoja menee; kolme autoa menee
            _ => det.n
            }) ;
        isPron = False
      } ;

    UsePN pn = {
      s = \\c => pn.s ! npform2case Sg c ; 
      a = agrP3 Sg ;
      isPron = False
      } ;
    UsePron p = p ** {isPron = True} ;

    PredetNP pred np = {
      s = \\c => pred.s ! complNumAgr np.a ! c ++ np.s ! c ;
      a = np.a ;
      isPron = np.isPron  -- kaikki minun - ni
      } ;

    PPartNP np v2 = {
      s = \\c => np.s ! c ++ v2.s ! PastPartPass (AN (NCase (complNumAgr np.a) Ess)) ;
      a = np.a ;
      isPron = np.isPron  -- minun täällä - ni
      } ;

    AdvNP np adv = {
      s = \\c => np.s ! c ++ adv.s ;
      a = np.a ;
      isPron = np.isPron  -- minun täällä - ni
      } ;

    DetQuantOrd quant num ord = {
      s = \\c => quant.s ! num.n ! c ++ num.s ! Sg ! c ++ ord.s ! NCase num.n c ; 
      sp = \\c => quant.sp ! num.n ! c ++ num.s ! Sg ! c ++ ord.s ! NCase num.n c ; 
      n = num.n ;
      isNum = num.isNum ;
      isDef = quant.isDef
      } ;

    DetQuant quant num = {
      s = \\c => quant.s ! num.n ! c ++ num.s ! Sg ! c ;
      sp = \\c => quant.sp ! num.n ! c ++ num.s ! Sg ! c ;
      n = num.n ;
      isNum = num.isNum ; -- case num.n of {Sg => False ; _ => True} ;
      isDef = quant.isDef
      } ;

    PossPron p = {
      s,sp = \\_,_ => p.s ! NPCase Gen ;
      isNum = False ;
      isDef = True  --- "minun kolme autoani ovat" ; thus "...on" is missing
      } ;

    NumSg = {s = \\_,_ => [] ; isNum = False ; n = Sg} ;
    NumPl = {s = \\_,_ => [] ; isNum = False ; n = Pl} ;

    NumCard n = n ** {isNum = case n.n of {Sg => False ; _ => True}} ;  -- yksi talo/kaksi taloa

    NumDigits numeral = {
      s = \\n,c => numeral.s ! NCard (NCase n c) ; 
      n = numeral.n 
      } ;
    OrdDigits numeral = {s = \\nc => numeral.s ! NOrd nc} ;

    NumNumeral numeral = {
      s = \\n,c => numeral.s ! NCard (NCase n c) ; 
      n = numeral.n
      } ;
    OrdNumeral numeral = {s = \\nc => numeral.s ! NOrd nc} ;

    AdNum adn num = {
      s = \\n,c => adn.s ++ num.s ! n ! c ; 
      n = num.n
      } ;

    -- OrdSuperl a = {s = \\nc => a.s ! Superl ! AN nc} ;
    -- TODO: it is more robust to use: kõige + Compar
    OrdSuperl a = {s = \\nc => "kõige" ++ a.s ! Compar ! AN nc} ;

    DefArt = {
      s = \\_,_ => [] ; 
      sp = table {Sg => pronSe.s ; Pl => pronNe.s} ; 
      isNum = False ;
      isDef = True   -- autot ovat
      } ;

    IndefArt = {
      s = \\_,_ => [] ; -- Nom is Part in Pl: use isDef in DetCN
      sp = \\n,c => 
         (nhn (mkSubst "üks" "ühe" "üht" "ühesse" "ühtede" 
         "ühtesid")).s ! NCase n c ; 
      isNum,isDef = False -- autoja on
      } ;

    MassNP cn =
      let
        n : Number = Sg ;
        ncase : Case -> NForm = \c -> NCase n c ;
      in {
        s = \\c => let k = npform2case n c in
                cn.s ! ncase k ; 
        a = agrP3 Sg ;
        isPron = False
      } ;

    UseN n = n ;

    UseN2 n = n ;

    Use2N3 f = {
      s = f.s ;
      c2 = f.c2 ;
      isPre = f.isPre
      } ;
    Use3N3 f = {
      s = f.s ;
      c2 = f.c3 ;
      isPre = f.isPre2
      } ;


--- If a possessive suffix is added here it goes after the complements...

    ComplN2 f x = {
      s = \\nf => preOrPost f.isPre (f.s ! nf) (appCompl True Pos f.c2 x)
      } ;
    ComplN3 f x = {
      s = \\nf => preOrPost f.isPre (f.s ! nf) (appCompl True Pos f.c2 x) ;
      c2 = f.c3 ;
      isPre = f.isPre2
      } ;

    AdjCN ap cn = {
      s = \\nf => ap.s ! True ! (n2nform nf) ++ cn.s ! nf
      } ;

    RelCN cn rs = {s = \\nf => cn.s ! nf ++ rs.s ! agrP3 (numN nf)} ;

    RelNP np rs = {
      s = \\c => np.s ! c ++ "," ++ rs.s ! np.a ; 
      a = np.a ;  
      isPron = np.isPron ---- correct ?
      } ;

    AdvCN cn ad = {s = \\nf => cn.s ! nf ++ ad.s} ;

    SentCN cn sc = {s = \\nf=> cn.s ! nf ++ sc.s} ;

    ApposCN cn np = {s = \\nf=> cn.s ! nf ++ np.s ! NPCase Nom} ; --- luvun x

  oper
    numN : NForm -> Number = \nf -> case nf of {
      NCase n _ => n ;
      _ => Sg ---
      } ;


}
