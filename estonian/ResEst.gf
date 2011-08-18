--# -path=.:../abstract:../common:../../prelude

--1 Finnish auxiliary operations.

-- This module contains operations that are needed to make the
-- resource syntax work. To define everything that is needed to
-- implement $Test$, it moreover contains regular lexical
-- patterns needed for $Lex$.

resource ResFin = ParamX ** open Prelude in {

  flags optimize=all ;


--2 Parameters for $Noun$

-- This is the $Case$ as needed for both nouns and $NP$s.

  param
    Case = Nom | Gen | Part | Transl | Ess 
         | Iness | Elat | Illat | Adess | Ablat | Allat 
         | Abess ;  -- Comit, Instruct in NForm 

    NForm = NCase Number Case 
          | NComit | NInstruct  -- no number dist
          | NPossNom Number | NPossGen Number --- number needed for syntax of AdjCN
          | NPossTransl Number | NPossIllat Number ;

-- Agreement of $NP$ has number*person and the polite second ("te olette valmis").


    Agr = Ag Number Person | AgPol ;

  oper
    complNumAgr : Agr -> Number = \a -> case a of {
      Ag n _ => n ;
      AgPol  => Sg
      } ;
    verbAgr : Agr -> {n : Number ; p : Person} = \a -> case a of {
      Ag n p => {n = n  ; p = p} ;
      AgPol  => {n = Pl ; p = P2}
      } ;

  oper
    NP = {s : NPForm => Str ; a : Agr ; isPron : Bool} ;

--
--2 Adjectives
--
-- The major division is between the comparison degrees. A degree fixed,
-- an adjective is like common nouns, except for the adverbial form.

param
  AForm = AN NForm | AAdv ;

oper
  Adjective : Type = {s : Degree => AForm => Str; lock_A : {}} ;

--2 Noun phrases
--
-- Two forms of *virtual accusative* are needed for nouns in singular, 
-- the nominative and the genitive one ("ostan talon"/"osta talo"). 
-- For nouns in plural, only a nominative accusative exist. Pronouns
-- have a uniform, special accusative form ("minut", etc).

param 
  NPForm = NPCase Case | NPAcc ;

oper
  npform2case : Number -> NPForm -> Case = \n,f ->

--  type signature: workaround for gfc bug 9/11/2007
    case <<f,n> : NPForm * Number> of {
      <NPCase c,_> => c ;
      <NPAcc,Sg>   => Gen ;-- appCompl does the job
      <NPAcc,Pl>   => Nom
    } ;

  n2nform : NForm -> NForm = \nf -> case nf of {
    NPossNom n => NCase n Nom ; ----
    NPossGen n  => NCase n Gen ;
    NPossTransl n => NCase n Transl ;
    NPossIllat n => NCase n Illat ;
    _ => nf
    } ;


--2 For $Verb$

-- A special form is needed for the negated plural imperative.

param
  VForm = 
     Inf InfForm
   | Presn Number Person
   | Impf Number Person  --# notpresent
   | Condit Number Person  --# notpresent
   | Imper Number
   | ImperP3 Number
   | ImperP1Pl
   | ImpNegPl
   | Pass Bool 
   | PastPartAct  AForm
   | PastPartPass AForm
   ;

  InfForm =
     Inf1
   | Inf3Iness  -- 5 forms acc. to Karlsson
   | Inf3Elat
   | Inf3Illat
   | Inf3Adess
   | Inf3Abess
   ;

  SType = SDecl | SQuest ;

--2 For $Relative$
 
    RAgr = RNoAg | RAg Agr ;

--2 For $Numeral$

    CardOrd = NCard NForm | NOrd NForm ;

--2 Transformations between parameter types

  oper
    agrP3 : Number -> Agr = \n -> 
      Ag n P3 ;

    conjAgr : Agr -> Agr -> Agr = \a,b -> case <a,b> of {
      <Ag n p, Ag m q> => Ag (conjNumber n m) (conjPerson p q) ;
      <Ag n p, AgPol>  => Ag Pl (conjPerson p P2) ;
      <AgPol,  Ag n p> => Ag Pl (conjPerson p P2) ;
      _ => b 
      } ;

---

  Compl : Type = {s : Str ; c : NPForm ; isPre : Bool} ;

  appCompl : Bool -> Polarity -> Compl -> NP -> Str = \isFin,b,co,np ->
    let
      c = case co.c of {
        NPAcc => case b of {
          Neg => NPCase Part ; -- en n�e taloa/sinua
          Pos => case isFin of {
               True => NPAcc ; -- n�en/t�ytyy n�hd� sinut
               _ => case np.isPron of {
                  False => NPCase Nom ;  -- t�ytyy n�hd� talo
                  _ => NPAcc
                  }
               }
          } ;
        _        => co.c
        } ;
{-
      c = case <isFin, b, co.c, np.isPron> of {
        <_,    Neg, NPAcc,_>      => NPCase Part ; -- en n�e taloa/sinua
        <_,    Pos, NPAcc,True>   => NPAcc ;       -- n�en/t�ytyy sinut
        <False,Pos, NPAcc,False>  => NPCase Nom ;  -- t�ytyy n�hd� talo
        <_,_,coc,_>               => coc
        } ;
-}
      nps = np.s ! c
    in
    preOrPost co.isPre co.s nps ;

-- For $Verb$.

  Verb : Type = {
    s : VForm => Str
    } ;

param
  VIForm =
     VIFin  Tense  
   | VIInf  InfForm
   | VIPass 
   | VIImper 
   ;  

oper
  VP = {
    s   : VIForm => Anteriority => Polarity => Agr => {fin, inf : Str} ; 
    s2  : Bool => Polarity => Agr => Str ; -- talo/talon/taloa
    adv : Polarity => Str ; -- ainakin/ainakaan
    ext : Str ;
    sc  : NPForm ;
    qp  : Bool -- True = back vowel
    } ;
    
  predV : (Verb ** {sc : NPForm ; qp : Bool}) -> VP = \verb -> {
    s = \\vi,ant,b,agr0 => 
      let

        agr = verbAgr agr0 ;
        verbs = verb.s ;
        part  : Str = case vi of {
          VIPass => verbs ! PastPartPass (AN (NCase agr.n Nom)) ; 
          _      => verbs ! PastPartAct (AN (NCase agr.n Nom))
          } ; 

        eiv : Str = case agr of {
          {n = Sg ; p = P1} => "en" ;
          {n = Sg ; p = P2} => "et" ;
          {n = Sg ; p = P3} => "ei" ;
          {n = Pl ; p = P1} => "emme" ;
          {n = Pl ; p = P2} => "ette" ;
          {n = Pl ; p = P3} => "eiv�t"
          } ;

        einegole : Str * Str * Str = case <vi,agr.n> of {
          <VIFin Pres,_>  => <eiv, verbs ! Imper Sg,     "ole"> ;
          <VIFin Fut,_>  => <eiv, verbs ! Imper Sg,     "ole"> ;   --# notpresent
          <VIFin Cond,        _>  => <eiv, verbs ! Condit Sg P3, "olisi"> ;  --# notpresent
          <VIFin Past,        Sg> => <eiv, part,                 "ollut"> ;  --# notpresent
          <VIFin Past,        Pl> => <eiv, part,                 "olleet"> ;  --# notpresent
          <VIImper,           Sg> => <"�l�", verbs ! Imper Sg,   "ole"> ;
          <VIImper,           Pl> => <"�lk��", verbs ! ImpNegPl, "olko"> ;
          <VIPass,            _>  => <"ei", verbs ! Pass False,  "ole"> ;
          <VIInf i,           _>  => <"ei", verbs ! Inf i, "olla"> ----
          } ;

        ei  : Str = einegole.p1 ;
        neg : Str = einegole.p2 ;
        ole : Str = einegole.p3 ;

        olla : VForm => Str = verbOlla.s ;

        vf : Str -> Str -> {fin, inf : Str} = \x,y -> 
          {fin = x ; inf = y} ;
        mkvf : VForm -> {fin, inf : Str} = \p -> case <ant,b> of {
          <Simul,Pos> => vf (verbs ! p) [] ;
          <Anter,Pos> => vf (olla ! p)  part ;    --# notpresent
          <Anter,Neg> => vf ei          (ole ++ part) ;   --# notpresent
          <Simul,Neg> => vf ei          neg
          }
      in
      case vi of {
        VIFin Past => mkvf (Impf agr.n agr.p) ;     --# notpresent
        VIFin Cond => mkvf (Condit agr.n agr.p) ;  --# notpresent
        VIFin Fut  => mkvf (Presn agr.n agr.p) ;  --# notpresent
        VIFin Pres => mkvf (Presn agr.n agr.p) ;
        VIImper    => mkvf (Imper agr.n) ;
        VIPass     => mkvf (Pass True) ;
        VIInf i    => mkvf (Inf i)
        } ;

    s2 = \\_,_,_ => [] ;
    adv = \\_ => [] ;
    ext = [] ;
    sc = verb.sc ;
    qp = verb.qp
    } ;

  insertObj : (Bool => Polarity => Agr => Str) -> VP -> VP = \obj,vp -> {
    s = vp.s ;
    s2 = \\fin,b,a => vp.s2 ! fin ! b ! a  ++ obj ! fin ! b ! a ;
    adv = vp.adv ;
    ext = vp.ext ;
    sc = vp.sc ; 
    qp = vp.qp
    } ;

  insertObjPre : (Bool => Polarity => Agr => Str) -> VP -> VP = \obj,vp -> {
    s = vp.s ;
    s2 = \\fin,b,a => obj ! fin ! b ! a ++ vp.s2 ! fin ! b ! a ;
    adv = vp.adv ;
    ext = vp.ext ;
    sc = vp.sc ; 
    qp = vp.qp
    } ;

  insertAdv : (Polarity => Str) -> VP -> VP = \adv,vp -> {
    s = vp.s ;
    s2 = vp.s2 ;
    ext = vp.ext ;
    adv = \\b => vp.adv ! b ++ adv ! b ;
    sc = vp.sc ; 
    qp = vp.qp
    } ;

  insertExtrapos : Str -> VP -> VP = \obj,vp -> {
    s = vp.s ;
    s2 = vp.s2 ;
    ext = vp.ext ++ obj ;
    adv = vp.adv ;
    sc = vp.sc ; 
    qp = vp.qp
    } ;

-- For $Sentence$.

  Clause : Type = {
    s : Tense => Anteriority => Polarity => SType => Str
    } ;

  ClausePlus : Type = {
    s : Tense => Anteriority => Polarity => {subj,fin,inf,compl,adv,ext : Str ; qp : Bool}
    } ;

  mkClause : (Polarity -> Str) -> Agr -> VP -> Clause = 
    \sub,agr,vp -> {
      s = \\t,a,b => let c = (mkClausePlus sub agr vp).s ! t ! a ! b in 
         table {
           SDecl  => c.subj ++ c.fin ++ c.inf ++ c.compl ++ c.adv ++ c.ext ;
           SQuest => c.fin ++ BIND ++ questPart c.qp ++ c.subj ++ c.inf ++ c.compl ++ c.adv ++ c.ext
           }
      } ;

  mkClausePlus : (Polarity -> Str) -> Agr -> VP -> ClausePlus =
    \sub,agr,vp -> {
      s = \\t,a,b => 
        let 
          agrfin = case vp.sc of {
                    NPCase Nom => <agr,True> ;
                    _ => <agrP3 Sg,False>      -- minun t�ytyy, minulla on
                    } ;
          verb  = vp.s ! VIFin t ! a ! b ! agrfin.p1 ;
        in {subj = sub b ; 
            fin  = verb.fin ; 
            inf  = verb.inf ; 
            compl = vp.s2 ! agrfin.p2 ! b ! agr ;
            adv  = vp.adv ! b ; 
            ext  = vp.ext ; 
            qp   = selectPart vp a b
            }
     } ;

  insertKinClausePlus : Predef.Ints 1 -> ClausePlus -> ClausePlus = \p,cl -> { 
    s = \\t,a,b =>
      let 
         c = cl.s ! t ! a ! b   
      in
      case p of {
         0 => {subj = c.subj ++ kin b True ; fin = c.fin ; inf = c.inf ;  -- Jussikin nukkuu
               compl = c.compl ; adv = c.adv ; ext = c.ext ; qp = c.qp} ;
         1 => {subj = c.subj ; fin = c.fin ++ kin b c.qp ; inf = c.inf ;  -- Jussi nukkuukin
               compl = c.compl ; adv = c.adv ; ext = c.ext ; qp = c.qp}
         }
    } ;

  insertObjClausePlus : Predef.Ints 1 -> Bool -> (Polarity => Str) -> ClausePlus -> ClausePlus = 
   \p,ifKin,obj,cl -> { 
    s = \\t,a,b =>
      let 
         c = cl.s ! t ! a ! b ;
         co = obj ! b ++ if_then_Str ifKin (kin b True) [] ;
      in case p of {
         0 => {subj = c.subj ; fin = c.fin ; inf = c.inf ; 
               compl = co ; adv = c.compl ++ c.adv ; ext = c.ext ; qp = c.qp} ; -- Jussi juo maitoakin
         1 => {subj = c.subj ; fin = c.fin ; inf = c.inf ; 
               compl = c.compl ; adv = co ; ext = c.adv ++ c.ext ; qp = c.qp}   -- Jussi nukkuu nytkin
         }
     } ;

  kin : Polarity -> Bool -> Str  = 
    \p,b -> case p of {Pos => (mkPart "kin" "kin").s ! b ; Neg => (mkPart "kaan" "k��n").s ! b} ;

  mkPart : Str -> Str -> {s : Bool => Str} = \ko,koe ->
    {s = table {True => glueTok ko ; False => glueTok koe}} ;

  glueTok : Str -> Str = \s -> "&+" ++ s ;


-- This is used for subjects of passives: therefore isFin in False.

  subjForm : NP -> NPForm -> Polarity -> Str = \np,sc,b -> 
    appCompl False b {s = [] ; c = sc ; isPre = True} np ;

  questPart : Bool -> Str = \b -> if_then_Str b "ko" "k�" ;

  selectPart : VP -> Anteriority -> Polarity -> Bool = \vp,a,p -> 
    case p of {
      Neg => False ;  -- eik� tule
      _ => case a of {
        Anter => True ; -- onko mennyt --# notpresent
        _ => vp.qp  -- tuleeko, meneek�
        }
      } ;

  infVP : NPForm -> Polarity -> Agr -> VP -> InfForm -> Str =
    \sc,pol,agr,vp,vi ->
        let 
          fin = case sc of {     -- subject case
            NPCase Nom => True ; -- min� tahdon n�hd� auton
            _ => False           -- minun t�ytyy n�hd� auto
            } ;
          verb  = vp.s ! VIInf vi ! Simul ! Pos ! agr ; -- no "ei"
          compl = vp.s2 ! fin ! pol ! agr ++ vp.ext     -- but compl. case propagated
        in
        verb.fin ++ verb.inf ++ compl ;

-- The definitions below were moved here from $MorphoFin$ so that we the
-- auxiliary of predication can be defined.

  verbOlla : Verb = 
    let olla = mkVerb 
      "olla" "on" "olen" "ovat" "olkaa" "ollaan" 
      "oli" "olin" "olisi" "ollut" "oltu" "ollun" ;
    in {s = table {
      Inf Inf3Iness => "olemassa" ;
      Inf Inf3Elat  => "olemasta" ;
      Inf Inf3Illat => "olemaan" ;
      Inf Inf3Adess => "olemalla" ;
      Inf Inf3Abess => "olematta" ;
      v => olla.s ! v
      }
    } ;
 

--3 Verbs
--
-- The present, past, conditional. and infinitive stems, acc. to Koskenniemi.
-- Unfortunately not enough (without complicated processes).
-- We moreover give grade alternation forms as arguments, since it does not
-- happen automatically.
--- A problem remains with the verb "seist�", where the infinitive
--- stem has vowel harmony "�" but the others "a", thus "seisoivat" but "seisk��".


  mkVerb : (_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> Verb = 
    \tulla,tulee,tulen,tulevat,tulkaa,tullaan,tuli,tulin,tulisi,tullut,tultu,tullun -> 
    v2v (mkVerbH 
     tulla tulee tulen tulevat tulkaa tullaan tuli tulin tulisi tullut tultu tullun
      ) ;

  v2v : VerbH -> Verb = \vh -> 
    let
      tulla = vh.tulla ; 
      tulee = vh.tulee ; 
      tulen = vh.tulen ; 
      tulevat = vh.tulevat ;
      tulkaa = vh.tulkaa ; 
      tullaan = vh.tullaan ; 
      tuli = vh.tuli ; 
      tulin = vh.tulin ;
      tulisi = vh.tulisi ;
      tullut = vh.tullut ;
      tultu = vh.tultu ;
      tultu = vh.tultu ;
      tullun = vh.tullun ;
      tuje = init tulen ;
      tuji = init tulin ;
      a = Predef.dp 1 tulkaa ;
      tulko = Predef.tk 2 tulkaa + (ifTok Str a "a" "o" "�") ;
      o = last tulko ;
      tulleena = Predef.tk 2 tullut + ("een" + a) ;
      tulleen = (noun2adj (nhn (sRae tullut tulleena))).s ;
      tullun = (noun2adj (nhn (sKukko tultu tullun (tultu + ("j"+a))))).s  ;
      tulema = Predef.tk 3 tulevat + "m" + a ;
----      tulema = tuje + "m" + a ;
      vat = "v" + a + "t"
    in
    {s = table {
      Inf Inf1 => tulla ;
      Presn Sg P1 => tuje + "n" ;
      Presn Sg P2 => tuje + "t" ;
      Presn Sg P3 => tulee ;
      Presn Pl P1 => tuje + "mme" ;
      Presn Pl P2 => tuje + "tte" ;
      Presn Pl P3 => tulevat ;
      Impf Sg P1 => tuji + "n" ;   --# notpresent
      Impf Sg P2 => tuji + "t" ;  --# notpresent
      Impf Sg P3 => tuli ;  --# notpresent
      Impf Pl P1 => tuji + "mme" ;  --# notpresent
      Impf Pl P2 => tuji + "tte" ;  --# notpresent
      Impf Pl P3 => tuli + vat ;  --# notpresent
      Condit Sg P1 => tulisi + "n" ;  --# notpresent
      Condit Sg P2 => tulisi + "t" ;  --# notpresent
      Condit Sg P3 => tulisi ;  --# notpresent
      Condit Pl P1 => tulisi + "mme" ;  --# notpresent
      Condit Pl P2 => tulisi + "tte" ;  --# notpresent
      Condit Pl P3 => tulisi + vat ;  --# notpresent
      Imper Sg   => tuje ;
      Imper Pl   => tulkaa ;
      ImperP3 Sg => tulko + o + "n" ;
      ImperP3 Pl => tulko + o + "t" ;
      ImperP1Pl  => tulkaa + "mme" ;
      ImpNegPl   => tulko ;
      Pass True  => tullaan ;
      Pass False => Predef.tk 2 tullaan ;
      PastPartAct n => tulleen ! n ;
      PastPartPass n => tullun ! n ;
      Inf Inf3Iness => tulema + "ss" + a ;
      Inf Inf3Elat  => tulema + "st" + a ;
      Inf Inf3Illat => tulema +  a   + "n" ;
      Inf Inf3Adess => tulema + "ll" + a ;
      Inf Inf3Abess => tulema + "tt" + a 
      }
    } ;

  VerbH : Type = {
    tulla,tulee,tulen,tulevat,tulkaa,tullaan,tuli,tulin,tulisi,tullut,tultu,tullun
      : Str
    } ;

  mkVerbH : (_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> VerbH = 
    \tulla,tulee,tulen,tulevat,tulkaa,tullaan,tuli,tulin,tulisi,tullut,tultu,tullun -> 
    {tulla = tulla ; 
     tulee = tulee ; 
     tulen = tulen ; 
     tulevat = tulevat ;
     tulkaa = tulkaa ; 
     tullaan = tullaan ; 
     tuli = tuli ; 
     tulin = tulin ;
     tulisi = tulisi ;
     tullut = tullut ;
     tultu = tultu ;
     tullun = tullun
     } ; 

  noun2adj : CommonNoun -> Adj = noun2adjComp True ;

  noun2adjComp : Bool -> CommonNoun -> Adj = \isPos,tuore ->
    let 
      tuoreesti  = Predef.tk 1 (tuore.s ! NCase Sg Gen) + "sti" ; 
      tuoreemmin = Predef.tk 2 (tuore.s ! NCase Sg Gen) + "in"
    in {s = table {
         AN f => tuore.s ! f ;
         AAdv => if_then_Str isPos tuoreesti tuoreemmin
         }
       } ;

  CommonNoun = {s : NForm => Str} ;

-- To form an adjective, it is usually enough to give a noun declension: the
-- adverbial form is regular.

  Adj : Type = {s : AForm => Str} ;

  NounH : Type = {
    a,vesi,vede,vete,vetta,veteen,vetii,vesii,vesien,vesia,vesiin : Str
    } ;

-- worst-case macro

  mkSubst : Str -> (_,_,_,_,_,_,_,_,_,_ : Str) -> NounH = 
    \a,vesi,vede,vete,vetta,veteen,vetii,vesii,vesien,vesia,vesiin -> 
    {a = a ;
     vesi = vesi ;
     vede = vede ;
     vete = vete ;
     vetta = vetta ;
     veteen = veteen ;
     vetii = vetii ;
     vesii = vesii ;
     vesien = vesien ;
     vesia = vesia ;
     vesiin = vesiin
    } ;

  nhn : NounH -> CommonNoun = \nh ->
    let
     a = nh.a ;
     vesi = nh.vesi ;
     vede = nh.vede ;
     vete = nh.vete ;
     vetta = nh.vetta ;
     veteen = nh.veteen ;
     vetii = nh.vetii ;
     vesii = nh.vesii ;
     vesien = nh.vesien ;
     vesia = nh.vesia ;
     vesiin = nh.vesiin
    in
    {s = table {
      NCase Sg Nom    => vesi ;
      NCase Sg Gen    => vede + "n" ;
      NCase Sg Part   => vetta ;
      NCase Sg Transl => vede + "ksi" ;
      NCase Sg Ess    => vete + ("n" + a) ;
      NCase Sg Iness  => vede + ("ss" + a) ;
      NCase Sg Elat   => vede + ("st" + a) ;
      NCase Sg Illat  => veteen ;
      NCase Sg Adess  => vede + ("ll" + a) ;
      NCase Sg Ablat  => vede + ("lt" + a) ;
      NCase Sg Allat  => vede + "lle" ;
      NCase Sg Abess  => vede + ("tt" + a) ;

      NCase Pl Nom    => vede + "t" ;
      NCase Pl Gen    => vesien ;
      NCase Pl Part   => vesia ;
      NCase Pl Transl => vesii + "ksi" ;
      NCase Pl Ess    => vetii + ("n" + a) ;
      NCase Pl Iness  => vesii + ("ss" + a) ;
      NCase Pl Elat   => vesii + ("st" + a) ;
      NCase Pl Illat  => vesiin ;
      NCase Pl Adess  => vesii + ("ll" + a) ;
      NCase Pl Ablat  => vesii + ("lt" + a) ;
      NCase Pl Allat  => vesii + "lle" ;
      NCase Pl Abess  => vesii + ("tt" + a) ;

      NComit    => vetii + "ne" ;
      NInstruct => vesii + "n" ;

      NPossNom _     => vete ;
      NPossGen Sg    => vete ;
      NPossGen Pl    => Predef.tk 1 vesien ;
      NPossTransl Sg => vede + "kse" ;
      NPossTransl Pl => vesii + "kse" ;
      NPossIllat Sg  => Predef.tk 1 veteen ;
      NPossIllat Pl  => Predef.tk 1 vesiin
      }
    } ;
-- Surpraisingly, making the test for the partitive, this not only covers
-- "rae", "perhe", "savuke", but also "rengas", "lyhyt" (except $Sg Illat$), etc.

  sRae : (_,_ : Str) -> NounH = \rae,rakeena ->
    let {
      a      = Predef.dp 1 rakeena ;
      rakee  = Predef.tk 2 rakeena ;
      rakei  = Predef.tk 1 rakee + "i" ;
      raet   = rae + (ifTok Str (Predef.dp 1 rae) "e" "t" [])
    } 
    in
    mkSubst a 
            rae
            rakee 
            rakee
            (raet + ("t" + a)) 
            (rakee + "seen")
            rakei
            rakei
            (rakei + "den") 
            (rakei + ("t" + a))
            (rakei + "siin") ;
-- Nouns with partitive "a"/"�" ; 
-- to account for grade and vowel alternation, three forms are usually enough
-- Examples: "talo", "kukko", "huippu", "koira", "kukka", "syyl�",...

  sKukko : (_,_,_ : Str) -> NounH = \kukko,kukon,kukkoja ->
    let {
      o      = Predef.dp 1 kukko ;
      a      = Predef.dp 1 kukkoja ;
      kukkoj = Predef.tk 1 kukkoja ;
      i      = Predef.dp 1 kukkoj ;
      ifi    = ifTok Str i "i" ;
      kukkoi = ifi kukkoj (Predef.tk 1 kukkoj) ;
      e      = Predef.dp 1 kukkoi ;
      kukoi  = Predef.tk 2 kukon + Predef.dp 1 kukkoi
    } 
    in
    mkSubst a 
            kukko 
            (Predef.tk 1 kukon) 
            kukko
            (kukko + a) 
            (kukko + o + "n")
            (kukkoi + ifi "" "i") 
            (kukoi + ifi "" "i") 
            (ifTok Str e "e" (Predef.tk 1 kukkoi + "ien") (kukkoi + ifi "en" "jen"))
            kukkoja
            (kukkoi + ifi "in" "ihin") ;

-- Reflexive pronoun. 
--- Possessive could be shared with the more general $NounFin.DetCN$.

oper
  reflPron : Agr -> NP = \agr -> 
    let 
      itse = (nhn (sKukko "itse" "itsen" "itsej�")).s ;
      nsa  = possSuffixFront agr
    in {
      s = table {
        NPCase (Nom | Gen) | NPAcc => itse ! NPossNom Sg + nsa ;
        NPCase Transl      => itse ! NPossTransl Sg + nsa ;
        NPCase Illat       => itse ! NPossIllat Sg + nsa ;
        NPCase c           => itse ! NCase Sg c + nsa
        } ;
      a = agr ;
      isPron = False -- no special acc form
      } ;

  possSuffixFront : Agr -> Str = \agr -> 
    table Agr ["ni" ; "si" ; "ns�" ; "mme" ; "nne" ; "ns�" ; "nne"] ! agr ;
  possSuffix : Agr -> Str = \agr -> 
    table Agr ["ni" ; "si" ; "nsa" ; "mme" ; "nne" ; "nsa" ; "nne"] ! agr ;

oper
  rp2np : Number -> {s : Number => NPForm => Str ; a : RAgr} -> NP = \n,rp -> {
    s = rp.s ! n ;
    a = agrP3 Sg ;  -- does not matter (--- at least in Slash)
    isPron = False  -- has no special accusative
    } ;

  etta_Conj : Str = "ett�" ;

    heavyDet : PDet -> PDet ** {sp : Case => Str} = \d -> d ** {sp = d.s1} ;
    PDet : Type = {
      s1 : Case => Str ;
      s2 : Str ;
      n : Number ;
      isNum : Bool ;
      isPoss : Bool ;
      isDef : Bool
      } ;

    heavyQuant : PQuant -> PQuant ** {sp : Number => Case => Str} = \d -> 
      d ** {sp = d.s1} ; 
    PQuant : Type =  
      {s1 : Number => Case => Str ; s2 : Str ; isPoss : Bool ; isDef : Bool} ; 

}
