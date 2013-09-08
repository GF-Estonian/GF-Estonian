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
   | Impf Number Person
   | Condit Number Person
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

  SType = SDecl | SQuest | SInv ;

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
    s : VForm => Str ;
    s2 : Str  -- particle verbs
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
          <VIFin Fut,    _>  => <eiv, verbs ! Imper Sg,     "ole"> ;
          <VIFin Cond,   _>  => <eiv, verbs ! Condit Sg P3, "oleks"> ;
          <VIFin Past,   Sg> => <eiv, part,                 "olnud"> ;
          <VIFin Past,   Pl> => <eiv, part,                 "olnud"> ;
          <VIImper,      Sg> => <"ära", verbs ! Imper Sg,   "ole"> ;
          <VIImper,      Pl> => <"ärge", verbs ! ImpNegPl,  "olge"> ;
          <VIPass,       _>  => <"ei", verbs ! PassPresn False,  "ole"> ;
          <VIInf i,      _>  => <"ei", verbs ! Inf i, "olla">
        } ;
        
        ei  : Str = einegole.p1 ;
        neg : Str = einegole.p2 ;
        ole : Str = einegole.p3 ;
        
        olla : VForm => Str = verbOlema.s ;
        
        vf : Str -> Str -> {fin, inf : Str} = \x,y -> {fin = x ; inf = y} ;
        
        mkvf : VForm -> {fin, inf : Str} = \p -> case <ant,b> of {
          <Simul,Pos> => vf (verbs ! p) [] ;
          <Anter,Pos> => vf (olla ! p)  part ; 
          <Anter,Neg> => vf ei          (ole ++ part) ;
          <Simul,Neg> => vf ei          neg
        }
   in case vi of {
        VIFin Past => mkvf (Impf agr.n agr.p) ;  
        VIFin Cond => mkvf (Condit agr.n agr.p) ;
        VIFin Fut  => mkvf (Presn agr.n agr.p) ;
        VIFin Pres => mkvf (Presn agr.n agr.p) ;
        VIImper    => mkvf (Imper agr.n) ;
        VIPass     => mkvf (PassPresn True) ;
        VIInf i    => mkvf (Inf i)
        } ;

    s2 = \\_,_,_ => [] ;
    adv = \\_ => [] ;
    --ext = [] ;
    ext = verb.s2 ; --particle verbs
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
    --ext = vp.ext ++ obj ;
    ext = obj ++ vp.ext ; --TODO test particle verbs
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
  -- Inari: added a third SType, SInv. 
  -- Not sure if SInv is needed, but keeping it for possible future use.
  -- There's need for an inverted word order with auxiliary verbs; infVP handles that. ComplVV calls infVP, which inverts the word order for the complement VP, and puts it into the resulting VP's `compl' field.
  -- SInv made by mkClause would be for cases where you just need to construct an inverted word order, and then call it from some other place; application grammar (TODO: api oper for SType) or ExtraEst.
  mkClause : (Polarity -> Str) -> Agr -> VP -> Clause = 
    \sub,agr,vp -> {
      s = \\t,a,b => 
      let
        c = (mkClausePlus sub agr vp).s ! t ! a ! b ;
        declCl = c.subj ++ c.fin ++ c.inf ++ c.compl ++ c.adv ++ c.ext ;
        invCl = c.subj ++ c.fin ++ c.adv ++ c.compl ++ c.ext ++ c.inf
      in 
         table {
           SDecl  => declCl ;
           SQuest => "kas" ++ declCl ;
           SInv   => invCl 
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
         1 => {subj = c.subj ; fin = c.fin ; inf = c.inf ; -- Jussi nukkuu nytkin
               compl = c.compl ; adv = co ; ext = c.adv ++ c.ext} --Not sure what is happening with adv becoming object and ext becoming adv++ext... also not sure if this holds anymore when ext is in its (new?) use as particle for particle verbs. TODO test this.
         }
     } ;

  kin : Polarity -> Str  = 
    \p -> case p of {Pos => "gi" ; Neg => "gi"} ;
  
  gi : Str = "gi" ;

  glueTok : Str -> Str = \s -> "&+" ++ s ;


-- This is used for subjects of passives: therefore isFin in False.

  subjForm : NP -> NPForm -> Polarity -> Str = \np,sc,b -> 
    appCompl False b {s = [] ; c = sc ; isPre = True} np ;

  infVP : NPForm -> Polarity -> Agr -> VP -> InfForm -> Str =
    \sc,pol,agr,vp,vi ->
        let 
          fin = case sc of {     -- subject case
            NPCase Nom => True ; -- mina tahan joosta
            _ => False           -- minul peab auto olema
            } ;
          verb  = vp.s ! VIInf vi ! Simul ! Pos ! agr ; -- no "ei"
          compl = vp.s2 ! fin ! pol ! agr  -- but compl. case propagated
        in
        -- inverted word order for; e.g.
        --sinust aru       saama       0     
        compl ++ vp.ext ++ verb.fin ++ verb.inf ;
        --for debugging, what gets where:
        --"<COMPL>" ++ compl ++ "</COMPL>" ++ vp.ext ++ "<FIN>" ++ verb.fin ++ "</FIN>" ++ "<INF>" ++ verb.inf ++ "</INF>" ;

-- The definitions below were moved here from $MorphoEst$ so that  
-- auxiliary of predication can be defined.

  verbOlema : Verb = 
    let olema = mkVerb
      "olema" "olla" "olen" "ollakse" 
      "olge" "oli" "olnud" "oldud"
     in {s = table {
      Presn _ P3 => "on" ;
      v => olema.s ! v
      } ;
      s2 = []
    } ;

  verbMinema : Verb = 
    let minema = mkVerb 
      "minema" "minna" "läheb" "minnakse" 
      "minge" "läks" "läinud" "mindud"
    in {s = table {
      Impf Sg P1 => "läksin" ;
      Impf Sg P2 => "läksid" ;
      Impf Pl P1 => "läksime" ;
      Impf Pl P2 => "läksite" ;
      Impf Pl P3 => "läksivad" ;
      Imper Sg => "mine" ;
      v => minema.s ! v
      } ;
      s2 = []
    } ;
    

--3 Verbs

  mkVerb : (x1,_,_,_,_,_,_,x8 : Str) -> Verb = 
    \tulema,tulla,tuleb,tullakse,tulge,tuli,tulnud,tuldud -> 
    v2v (mkVerbH 
     tulema tulla tuleb tullakse tulge tuli tulnud tuldud
      ) ;

  v2v : VerbH -> Verb = \vh -> 
    let
      tulema = vh.tulema ;
      tulla = vh.tulla ;
      tuleb = vh.tuleb ; 
      tullakse = vh.tullakse ;
      tulge = vh.tulge ; 
      tuli = vh.tuli ; 
      tulnud = vh.tulnud ;
      tuldud = vh.tuldud ;

      tule_ = init tuleb ;
      tull_ = init tulla ;
      tuld_ = Predef.tk 2 tuldud ;
      tulles = tull_ + "es" ; 
      tulgu = (init tulge) + "e" ;

      lugenud = (nhn (sMaakas tulnud)).s ;
      loetud = (nhn (sMaakas tuldud)).s ;
    in
    {s = table {
      Inf InfDa => tulla ;
      Inf InfDes => tulles ;
      Presn Sg P1 => tule_ + "n" ;
      Presn Sg P2 => tule_ + "d" ;
      Presn Sg P3 => tuleb ;
      Presn Pl P1 => tule_ + "me" ;
      Presn Pl P2 => tule_ + "te" ;
      Presn Pl P3 => tule_ + "vad" ;
      Impf Sg P1  => tuli + "n" ;
      Impf Sg P2  => tuli + "d" ;
      Impf Sg P3  => tuli ;
      Impf Pl P1  => tuli + "me" ;
      Impf Pl P2  => tuli + "te" ;
      Impf Pl P3  => tuli + "d" ;
      Condit Sg P1 => tule_ + "ksin" ;
      Condit Sg P2 => tule_ + "ksid" ;
      Condit Sg P3 => tule_ + "ks";
      Condit Pl P1 => tule_ + "ksime" ;
      Condit Pl P2 => tule_ + "ksite" ;
      Condit Pl P3 => tule_ + "ksid" ;
      Imper Sg   => tule_ ; 
      Imper Pl   => tulge ; 
      ImperP3 Sg => tulgu ;  
      ImperP3 Pl => tulgu ; 
      ImperP1Pl  => tulge + "m" ;
      ImpNegPl   => tulge ;
      PassPresn True  => tullakse ;
      PassPresn False => tuld_ + "a" ; 
      PassImpf  True  => tuld_ + "i" ; 
      PassImpf  False => tuldud ;  
      PresPart => tule_ + "v" ;
      PastPartAct (AN n)  => lugenud ! n ;
      PastPartAct AAdv    => lugenud ! (NCase Sg Ablat) ;
      PastPartPass (AN n) => loetud ! n ;
      PastPartPass AAdv   => loetud ! (NCase Sg Ablat) ;
      Inf InfMa => tulema ;
      Inf InfMas => tulema + "s" ;
      Inf InfMast => tulema + "st" ;
      Inf InfMata => tulema + "ta" ;
      Inf InfMaks => tulema + "ks" 
      } ;
      s2 = [] 
  } ;

  VerbH : Type = {
    tulema,tulla,tuleb,tullakse,tulge,tuli,tulnud,tuldud
      : Str
    } ;

  mkVerbH : (x1,_,_,_,_,_,_,x8 : Str) -> VerbH = 
    \tulema,tulla,tuleb,tullakse,tulge,tuli,tulnud,tuldud -> 
    {
     tulema = tulema ;
     tulla = tulla ; 
     tuleb = tuleb ; 
     tullakse = tullakse ; 
     tulge = tulge ; 
     tuli = tuli ; 
     tulnud = tulnud ;
     tuldud = tuldud 
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
    maakas,maaka,maakat,maakasse,maakate,maakaid : Str
    } ;

-- worst-case macro

  mkSubst : (x1,_,_,_,_,x6 : Str) -> NounH = 
    \maakas,maaka,maakat,maakasse,maakate,maakaid -> 
    {
     maakas = maakas ;
     maaka = maaka ;
     maakat = maakat ;
     maakasse = maakasse ;
     maakate = maakate ;
     maakaid = maakaid ;
    } ;

  nhn : NounH -> CommonNoun = \nh ->
    let
     maakas = nh.maakas ;
     maaka = nh.maaka ;
     maakat = nh.maakat ;
     maakasse = nh.maakasse ;
     maakate = nh.maakate ;
     maakaid = nh.maakaid ;
    in
      nForms6
        maakas
        maaka
        maakat
        maakasse
        maakate
        maakaid ;

  sMaakas : (_ : Str) -> NounH = \maakas ->
    let
      maaka = init maakas ;
    in 
      mkSubst maakas
              maaka
              (maaka + "t")
              (maaka + "sse")
              (maaka + "te")
              (maaka + "id") ;

-- Reflexive pronoun. 
--- Possessive could be shared with the more general $NounFin.DetCN$.

--oper
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


    -- Converts 6 given strings (Nom, Gen, Part, Illat, Gen, Part) into CommonNoun
    -- http://www.eki.ee/books/ekk09/index.php?p=3&p1=5&id=226
    nForms6 : (jogi,joe,joge,joesse,jogede,jogesid : Str) -> CommonNoun ;

    nForms6 jogi joe joge joesse jogede jogesid = 
    {s = table {
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
        }
    } ;


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
