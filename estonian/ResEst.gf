--# -path=.:../abstract:../common:../../prelude

--1 Estonian auxiliary operations.

-- This module contains operations that are needed to make the
-- resource syntax work. To define everything that is needed to
-- implement $Test$, it moreover contains regular lexical
-- patterns needed for $Lex$.

resource ResEst = ParamX ** open Prelude in {

  flags optimize=all ; coding=utf8;


--2 Parameters for $Noun$

-- This is the $Case$ as needed for both nouns and $NP$s.

  param
    Case = Nom | Gen | Part  
         | Illat | Iness | Elat | Allat | Adess | Ablat 
         | Transl | Ess | Termin | Abess | Comit;

    NForm = NCase Number Case ; 


--Not in Estonian
{-          | NComit  | NInstruct  -- no number dist
          | NPossNom Number | NPossGen Number --- number needed for syntax of AdjCN
          | NPossTransl Number | NPossIllat Number ;
-}

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

  n2nform : NForm -> NForm = \nf -> nf ; 
{-
\nf -> case nf of {
    NPossNom n => NCase n Nom ; ----
    NPossGen n  => NCase n Gen ;
    NPossTransl n => NCase n Transl ;
    NPossIllat n => NCase n Illat ;
    _ => nf
    } ;
-}

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
   | PassPresn Bool
   | PassImpf Bool
   | PresPart
   | PastPartAct  AForm
   | PastPartPass AForm
   ;

  InfForm =
     InfDa     -- lugeda
   | InfDes    -- lugedes 
   | InfMa     -- lugema  
   | InfMas    -- lugemas
   | InfMast   -- lugemast
   | InfMata   -- lugemata
   | InfMaks   -- lugemaks
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
          Neg => NPCase Part ; -- en näe taloa/sinua
          Pos => case isFin of {
               True => NPAcc ; -- näen/täytyy nähdä sinut
               _ => case np.isPron of {
                  False => NPCase Nom ;  -- täytyy nähdä talo
                  _ => NPAcc
                  }
               }
          } ;
        _        => co.c
        } ;
{-
      c = case <isFin, b, co.c, np.isPron> of {
        <_,    Neg, NPAcc,_>      => NPCase Part ; -- en näe taloa/sinua
        <_,    Pos, NPAcc,True>   => NPAcc ;       -- näen/täytyy sinut
        <False,Pos, NPAcc,False>  => NPCase Nom ;  -- täytyy nähdä talo
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
    } ;
    
  predV : (Verb ** {sc : NPForm}) -> VP = \verb -> {
    s = \\vi,ant,b,agr0 => 
      let
        agr = verbAgr agr0 ;
        verbs = verb.s ;
        part  : Str = case vi of {
          VIPass => verbs ! PastPartPass (AN (NCase agr.n Nom)) ; 
          _      => verbs ! PastPartAct (AN (NCase agr.n Nom))
          } ; 

  eiv : Str = case agr of {
    _ => "ei"
  } ;

  einegole : Str * Str * Str = case <vi,agr.n> of {
    <VIFin Pres,   _>  => <eiv, verbs ! Imper Sg,     "ole"> ;
    <VIFin Fut,    _>  => <eiv, verbs ! Imper Sg,     "ole"> ;   --# notpresent
    <VIFin Cond,   _>  => <eiv, verbs ! Condit Sg P3, "oleks"> ;  --# notpresent
    <VIFin Past,   Sg> => <eiv, part,                 "olnud"> ;  --# notpresent
    <VIFin Past,   Pl> => <eiv, part,                 "olnud"> ;  --# notpresent
    <VIImper,      Sg> => <"ära", verbs ! Imper Sg,   "ole"> ;
    <VIImper,      Pl> => <"ärge", verbs ! ImpNegPl,  "olge"> ;
    <VIPass,       _>  => <"ei", verbs ! PassPresn False,  "ole"> ;
    <VIInf i,      _>  => <"ei", verbs ! Inf i, "olla">
  } ;

  ei  : Str = einegole.p1 ;
  neg : Str = einegole.p2 ;
  ole : Str = einegole.p3 ;

  olla : VForm => Str = verbOlla.s ;

  vf : Str -> Str -> {fin, inf : Str} = \x,y -> {fin = x ; inf = y} ;
  mkvf : VForm -> {fin, inf : Str} = \p -> case <ant,b> of {
    <Simul,Pos> => vf (verbs ! p) [] ;
    <Anter,Pos> => vf (olla ! p)  part ;    --# notpresent
    <Anter,Neg> => vf ei          (ole ++ part) ;   --# notpresent
    <Simul,Neg> => vf ei          neg
  } in case vi of {
        VIFin Past => mkvf (Impf agr.n agr.p) ;     --# notpresent
        VIFin Cond => mkvf (Condit agr.n agr.p) ;  --# notpresent
        VIFin Fut  => mkvf (Presn agr.n agr.p) ;  --# notpresent
        VIFin Pres => mkvf (Presn agr.n agr.p) ;
        VIImper    => mkvf (Imper agr.n) ;
        VIPass     => mkvf (PassPresn True) ;
        VIInf i    => mkvf (Inf i)
        } ;

    s2 = \\_,_,_ => [] ;
    adv = \\_ => [] ;
    ext = [] ;
    sc = verb.sc 
    } ;

  insertObj : (Bool => Polarity => Agr => Str) -> VP -> VP = \obj,vp -> {
    s = vp.s ;
    s2 = \\fin,b,a => vp.s2 ! fin ! b ! a  ++ obj ! fin ! b ! a ;
    adv = vp.adv ;
    ext = vp.ext ;
    sc = vp.sc ; 
    } ;

  insertObjPre : (Bool => Polarity => Agr => Str) -> VP -> VP = \obj,vp -> {
    s = vp.s ;
    s2 = \\fin,b,a => obj ! fin ! b ! a ++ vp.s2 ! fin ! b ! a ;
    adv = vp.adv ;
    ext = vp.ext ;
    sc = vp.sc ; 
    } ;

  insertAdv : (Polarity => Str) -> VP -> VP = \adv,vp -> {
    s = vp.s ;
    s2 = vp.s2 ;
    ext = vp.ext ;
    adv = \\b => vp.adv ! b ++ adv ! b ;
    sc = vp.sc ; 
    } ;

  insertExtrapos : Str -> VP -> VP = \obj,vp -> {
    s = vp.s ;
    s2 = vp.s2 ;
    ext = vp.ext ++ obj ;
    adv = vp.adv ;
    sc = vp.sc ; 
    } ;

-- For $Sentence$.

  Clause : Type = {
    s : Tense => Anteriority => Polarity => SType => Str
    } ;

  ClausePlus : Type = {
    s : Tense => Anteriority => Polarity => {subj,fin,inf,compl,adv,ext : Str}
    } ;

  -- The Finnish version of SQuest featured a word order change and
  -- the question particle "ko". The Estonian version just prefixes the
  -- declarative sentence with the yes/no-queryword "kas".
  -- SQuest: "kas" + SDecl
  -- It would be also correct to use the Finnish structure, just without the ko-particle.
  mkClause : (Polarity -> Str) -> Agr -> VP -> Clause = 
    \sub,agr,vp -> {
      s = \\t,a,b => let c = (mkClausePlus sub agr vp).s ! t ! a ! b in 
         table {
           SDecl  => c.subj ++ c.fin ++ c.inf ++ c.compl ++ c.adv ++ c.ext ;
           SQuest => "kas" ++ c.subj ++ c.fin ++ c.inf ++ c.compl ++ c.adv ++ c.ext
           }
      } ;

  mkClausePlus : (Polarity -> Str) -> Agr -> VP -> ClausePlus =
    \sub,agr,vp -> {
      s = \\t,a,b => 
        let 
          agrfin = case vp.sc of {
                    NPCase Nom => <agr,True> ;
                    _ => <agrP3 Sg,False>      -- minun täytyy, minulla on
                    } ;
          verb  = vp.s ! VIFin t ! a ! b ! agrfin.p1 ;
        in {subj = sub b ; 
            fin  = verb.fin ; 
            inf  = verb.inf ; 
            compl = vp.s2 ! agrfin.p2 ! b ! agr ;
            adv  = vp.adv ! b ; 
            ext  = vp.ext ; 
            }
     } ;

  insertKinClausePlus : Predef.Ints 1 -> ClausePlus -> ClausePlus = \p,cl -> { 
    s = \\t,a,b =>
      let 
         c = cl.s ! t ! a ! b   
      in
      case p of {
         0 => {subj = c.subj ++ kin b ; fin = c.fin ; inf = c.inf ;  -- Jussikin nukkuu
               compl = c.compl ; adv = c.adv ; ext = c.ext} ;
         1 => {subj = c.subj ; fin = c.fin ++ kin b ; inf = c.inf ;  -- Jussi nukkuukin 
               compl = c.compl ; adv = c.adv ; ext = c.ext}
         }
    } ;

  insertObjClausePlus : Predef.Ints 1 -> Bool -> (Polarity => Str) -> ClausePlus -> ClausePlus = 
   \p,ifKin,obj,cl -> { 
    s = \\t,a,b =>
      let 
         c = cl.s ! t ! a ! b ;
         co = obj ! b ++ if_then_Str ifKin (kin b) [] ;
      in case p of {
         0 => {subj = c.subj ; fin = c.fin ; inf = c.inf ; 
               compl = co ; adv = c.compl ++ c.adv ; ext = c.ext} ; -- Jussi juo maitoakin
         1 => {subj = c.subj ; fin = c.fin ; inf = c.inf ; 
               compl = c.compl ; adv = co ; ext = c.adv ++ c.ext}   -- Jussi nukkuu nytkin
         }
     } ;

  kin : Polarity -> Str  = 
    \p -> case p of {Pos => "gi" ; Neg => "gi"} ;

  --mkPart : Str -> Str -> {s : Bool => Str} = \ko,koe ->
  --  {s = table {True => glueTok ko ; False => glueTok koe}} ;

  glueTok : Str -> Str = \s -> "&+" ++ s ;


-- This is used for subjects of passives: therefore isFin in False.

  subjForm : NP -> NPForm -> Polarity -> Str = \np,sc,b -> 
    appCompl False b {s = [] ; c = sc ; isPre = True} np ;

{-  -- TODO: remove: Estonian does not have question particles
  questPart : Bool -> Str = \b -> if_then_Str b "ko" "kö" ;

  selectPart : VP -> Anteriority -> Polarity -> Bool = \vp,a,p -> 
    case p of {
      Neg => False ;  -- eikö tule
      _ => case a of {
        Anter => True ; -- onko mennyt --# notpresent
        _ => vp.qp  -- tuleeko, meneekö
        }
      } ;
-}

  infVP : NPForm -> Polarity -> Agr -> VP -> InfForm -> Str =
    \sc,pol,agr,vp,vi ->
        let 
          fin = case sc of {     -- subject case
            NPCase Nom => True ; -- minä tahdon nähdä auton
            _ => False           -- minun täytyy nähdä auto
            } ;
          verb  = vp.s ! VIInf vi ! Simul ! Pos ! agr ; -- no "ei"
          compl = vp.s2 ! fin ! pol ! agr ++ vp.ext     -- but compl. case propagated
        in
        verb.fin ++ verb.inf ++ compl ;

-- The definitions below were moved here from $MorphoFin$ so that we the
-- auxiliary of predication can be defined.

  -- Inf1, SgP3, ~PgP1, PlP3, ImperPl, PassTrue?
  -- ImpfSgP3, ImpfSgP1, ConditSgP3?, ??, ??, ??
  verbOlla : Verb = 
    let olla = mkVerb 
      "olema"
      "olla" "on" "olen" "on" "olge" "ollakse" 
      "oli" "olin" "oleks" "ollut" "oltu" "ollun" ;
    in {s = table {
      Inf InfMas => "olemas" ;
      Inf InfMast => "olemast" ;
      Inf InfMata => "olemata" ;
      Inf InfMaks => "olemaks" ;
      v => olla.s ! v
      }
    } ;
 

--3 Verbs
--
-- The present, past, conditional. and infinitive stems, acc. to Koskenniemi.
-- Unfortunately not enough (without complicated processes).
-- We moreover give grade alternation forms as arguments, since it does not
-- happen automatically.
--- A problem remains with the verb "seistä", where the infinitive
--- stem has vowel harmony "ä" but the others "a", thus "seisoivat" but "seiskää".


  mkVerb : (_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> Verb = 
    \tulema,tulla,tulee,tulen,tulevat,tulkaa,tullaan,tuli,tulin,tulisi,tullut,tultu,tullun -> 
    v2v (mkVerbH 
     tulema tulla tulee tulen tulevat tulkaa tullaan tuli tulin tulisi tullut tultu tullun
      ) ;

  v2v : VerbH -> Verb = \vh -> 
    let
      tulema = vh.tulema ;
      tulla = vh.tulla ; 
      tulles = "TODO" ;
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
      tullun = vh.tullun ;
      tuje = init tulen ;
      tuji = init tulin ;
      a = Predef.dp 1 tulkaa ;
      tulko = Predef.tk 2 tulkaa + (ifTok Str a "a" "o" "ö") ;
      o = last tulko ;
      tulleena = Predef.tk 2 tullut + ("een" + a) ;
      tulleen = (noun2adj (nhn (sRae tullut tulleena))).s ;
      tullun = (noun2adj (nhn (sKukko tultu tullun (tultu + ("j"+a))))).s
    in
    {s = table {
      Inf InfDa => tulla ;
      Inf InfDes => tulles ;
      Presn Sg P1 => tuje + "n" ;
      Presn Sg P2 => tuje + "d" ;
      Presn Sg P3 => tulee ;
      Presn Pl P1 => tuje + "me" ;
      Presn Pl P2 => tuje + "te" ;
      Presn Pl P3 => tulevat ;
      Impf Sg P1 => tuji + "n" ;   --# notpresent
      Impf Sg P2 => tuji + "d" ;  --# notpresent
      Impf Sg P3 => tuli ;  --# notpresent
      Impf Pl P1 => tuji + "me" ;  --# notpresent
      Impf Pl P2 => tuji + "te" ;  --# notpresent
      Impf Pl P3 => tuli + "d" ;  --# notpresent
      Condit Sg P1 => tulisi + "in" ;  --# notpresent
      Condit Sg P2 => tulisi + "id" ;  --# notpresent
      Condit Sg P3 => tulisi ;  --# notpresent
      Condit Pl P1 => tulisi + "ime" ;  --# notpresent
      Condit Pl P2 => tulisi + "ite" ;  --# notpresent
      Condit Pl P3 => tulisi + "id";  --# notpresent
      Imper Sg   => tuje ;
      Imper Pl   => tulkaa ;
      ImperP3 Sg => tulko + o + "n" ;
      ImperP3 Pl => tulko + o + "t" ;
      ImperP1Pl  => tulkaa + "mme" ;
      ImpNegPl   => tulko ;
      PassPresn True  => tullaan ;
      PassPresn False => Predef.tk 2 tullaan ;
      PassImpf True  => tullaan ;
      PassImpf False => Predef.tk 2 tullaan ;
      PresPart => "TODO" ;
      PastPartAct n => tulleen ! n ;
      PastPartPass n => tullun ! n ;
      Inf InfMa => tulema ;
      Inf InfMas => tulema + "s" ; -- -mas
      Inf InfMast  => tulema + "st" ; -- -mast
      Inf InfMaks => tulema + "ks" ; -- -maks (missing in Finnish)
      Inf InfMata => tulema + "ta" -- -mata
      }
    } ;

  VerbH : Type = {
    tulema,tulla,tulee,tulen,tulevat,tulkaa,tullaan,tuli,tulin,tulisi,tullut,tultu,tullun
      : Str
    } ;

  mkVerbH : (_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> VerbH = 
    \tulema,tulla,tulee,tulen,tulevat,tulkaa,tullaan,tuli,tulin,tulisi,tullut,tultu,tullun -> 
    {
     tulema = tulema ;
     tulla = tulla ; 
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

  -- TODO: remove the unused arguments and clean up the code
  -- TODO: AAdv is current just Sg Ablat, which seems OK in most cases, although
  -- ilus -> ilusti | ilusalt?
  -- hea -> hästi
  -- parem -> paremini
  -- parim -> kõige paremini | parimalt?
  noun2adjComp : Bool -> CommonNoun -> Adj = \isPos,tuore ->
    let 
      tuoreesti  = Predef.tk 1 (tuore.s ! NCase Sg Gen) + "sti" ; 
      tuoreemmin = Predef.tk 2 (tuore.s ! NCase Sg Gen) + "in"
    in {s = table {
         AN f => tuore.s ! f ;
         -- AAdv => if_then_Str isPos tuoreesti tuoreemmin
         AAdv => tuore.s ! NCase Sg Ablat
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
      NCase Sg Transl => vede + "ks" ;
      NCase Sg Ess    => vete + ("n" + a) ;
      NCase Sg Iness  => vede + ("ss" + a) ;
      NCase Sg Elat   => vede + "st" ;
      NCase Sg Illat  => veteen ;
      NCase Sg Adess  => vede + "l" ;
      NCase Sg Ablat  => vede + "lt" ;
      NCase Sg Allat  => vede + "le" ;
      NCase Sg Abess  => vede + ("t" + a) ;
      NCase Sg Comit  => vede + "ga" ;
      NCase Sg Termin => vede + "ni" ;

      NCase Pl Nom    => vede + "d" ;
      NCase Pl Gen    => vesien ;
      NCase Pl Part   => vesia ;
      NCase Pl Transl => vesii + "ks" ;
      NCase Pl Ess    => vetii + ("n" + a) ;
      NCase Pl Iness  => vesii + ("ss" + a) ;
      NCase Pl Elat   => vesii + "st" ;
      NCase Pl Illat  => vesiin ;
      NCase Pl Adess  => vesii + ("l" + a) ;
      NCase Pl Ablat  => vesii + "lt" ;
      NCase Pl Allat  => vesii + "le" ;
      NCase Pl Abess  => vesii + ("t" + a) ;
      NCase Pl Comit  => vesii + "ga" ;
      NCase Pl Termin => vesii + "ni" 

{-    --Not in Estonian
      NComit    => vede + "ga" ;
      NInstruct => vesii + "n" ;

      NPossNom _     => vete ;
      NPossGen Sg    => vete ;
      NPossGen Pl    => Predef.tk 1 vesien ;
      NPossTransl Sg => vede + "kse" ;
      NPossTransl Pl => vesii + "kse" ;
      NPossIllat Sg  => Predef.tk 1 veteen ;
      NPossIllat Pl  => Predef.tk 1 vesiin
-}
      }
    } ;
-- Surprisingly, making the test for the partitive, this not only covers
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
-- Nouns with partitive "a"/"ä" ; 
-- to account for grade and vowel alternation, three forms are usually enough
-- Examples: "talo", "kukko", "huippu", "koira", "kukka", "syylä",...

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
  --Estonian version started
  reflPron : Agr -> NP = \agr -> 
    let 
      ise = nForms6 "ise" "enda" "ennast" "endasse" "IGNORE" "IGNORE"
    in {
      s = table {
        NPAcc => "ennast" ;
        NPCase c => ise.s ! NCase Sg c
        } ;
      a = agr ;
      isPron = False -- no special acc form
      } ;


    -- Converts 6 given strings (Nom, Gen, Part, Illat, Gen, Part) into Noun
    -- http://www.eki.ee/books/ekk09/index.php?p=3&p1=5&id=226
    nForms6 : (jogi,joe,joge,joesse,jogede,jogesid : Str) -> {s : NForm => Str} ;

    nForms6 jogi joe joge joesse jogede jogesid = {s = table {
        NCase Sg Nom    => jogi ;
        NCase Sg Gen    => joe ;
        NCase Sg Part   => joge ;
        NCase Sg Transl => joe + "ks" ;
        NCase Sg Ess    => joe + "na" ;
        NCase Sg Iness  => joe + "s" ;
        NCase Sg Elat   => joe + "st" ;
        NCase Sg Illat  => joesse ;
        NCase Sg Adess  => joe + "l" ;
        NCase Sg Ablat  => joe + "lt" ;
        NCase Sg Allat  => joe + "le" ;
        NCase Sg Abess  => joe + "ta" ;
        NCase Sg Comit  => joe + "ga" ;
        NCase Sg Termin => joe + "ni" ;

        NCase Pl Nom    => joe + "d" ;
        NCase Pl Gen    => jogede ;
        NCase Pl Part   => jogesid ;
        NCase Pl Transl => jogede + "ks" ;
        NCase Pl Ess    => jogede + "na" ;
        NCase Pl Iness  => jogede + "s" ;
        NCase Pl Elat   => jogede + "st" ;
        NCase Pl Illat  => jogede + "sse" ;
        NCase Pl Adess  => jogede + "l" ;
        NCase Pl Ablat  => jogede + "lt" ;
        NCase Pl Allat  => jogede + "le" ;
        NCase Pl Abess  => jogede + "ta" ;
        NCase Pl Comit  => jogede + "ga" ;
        NCase Pl Termin => jogede + "ni"
    } } ;


oper
  rp2np : Number -> {s : Number => NPForm => Str ; a : RAgr} -> NP = \n,rp -> {
    s = rp.s ! n ;
    a = agrP3 Sg ;  -- does not matter (--- at least in Slash)
    isPron = False  -- has no special accusative
    } ;

  etta_Conj : Str = "et" ;

    heavyDet : PDet -> PDet ** {sp : Case => Str} = \d -> d ** {sp = d.s} ;
    PDet : Type = {
      s : Case => Str ;
      n : Number ;
      isNum : Bool ;
      isDef : Bool
      } ;

    heavyQuant : PQuant -> PQuant ** {sp : Number => Case => Str} = \d -> 
      d ** {sp = d.s} ; 
    PQuant : Type =  
      {s : Number => Case => Str ; isDef : Bool} ; 

}
