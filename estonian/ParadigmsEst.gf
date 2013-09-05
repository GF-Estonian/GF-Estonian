--# -path=.:../abstract:../common:../../prelude

--1 Estonian Lexical Paradigms
--
-- Based on the Finnish Lexical Paradigms by Aarne Ranta 2003--2008
--
-- This is an API to the user of the resource grammar 
-- for adding lexical items. It gives functions for forming
-- expressions of open categories: nouns, adjectives, verbs.
-- 
-- Closed categories (determiners, pronouns, conjunctions) are
-- accessed through the resource syntax API and $Structural.gf$. 
--
-- The main difference with $MorphoEst.gf$ is that the types
-- referred to are compiled resource grammar types. We have moreover
-- had the design principle of always having existing forms, rather
-- than stems, as string arguments of the paradigms.
--
-- The structure of functions for each word class $C$ is the following:
-- there is a polymorphic constructor $mkC$, which takes one or
-- a few arguments. In Estonian, one argument is enough in ??? % of
-- cases in average.

resource ParadigmsEst = open 
  (Predef=Predef), 
  Prelude, 
  MorphoEst,
  HjkEst,
  CatEst
  in {

  flags optimize=noexpand ; coding=utf8;

--2 Parameters 
--
-- To abstract over gender, number, and (some) case names, 
-- we define the following identifiers. The application programmer
-- should always use these constants instead of the constructors
-- defined in $ResEst$.

oper
  Number   : Type ;

  singular : Number ;
  plural   : Number ;

  Case        : Type ;
  nominative  : Case ; -- e.g. "karp"
  genitive    : Case ; -- e.g. "karbi"
  partitive   : Case ; -- e.g. "karpi"
  illative    : Case ; -- e.g. "karbisse/karpi"
  inessive    : Case ; -- e.g. "karbis"
  elative     : Case ; -- e.g. "karbist"
  allative    : Case ; -- e.g. "karbile"
  adessive    : Case ; -- e.g. "karbil"
  ablative    : Case ; -- e.g. "karbilt"
  translative : Case ; -- e.g. "karbiks"
  terminative : Case ; -- e.g. "karbini"
  essive      : Case ; -- e.g. "karbina"
  abessive    : Case ; -- e.g. "karbita"
  comitative  : Case ; -- e.g. "karbiga"

  infDa : InfForm ; -- e.g. "lugeda"
  infMa : InfForm ; -- e.g. "lugema"
  infMast : InfForm ;  -- e.g. "lugemast"

-- The following type is used for defining *rection*, i.e. complements
-- of many-place verbs and adjective. A complement can be defined by
-- just a case, or a pre/postposition and a case.

  prePrep     : Case -> Str -> Prep ;  -- preposition, e.g. comitative "koos"
  postPrep    : Case -> Str -> Prep ;  -- postposition, e.g. genitive "taga"
  postGenPrep :         Str -> Prep ;  -- genitive postposition, e.g. "taga"
  casePrep    : Case ->        Prep ;  -- just case, e.g. adessive

  -- TODO build the dict 
  NW : Type ;   -- Noun from DictEst (WordNet)
  AW : Type ;   -- Adjective from DictEst (WordNet)
  VW : Type ;   -- Verb from DictEst (WordNet)
  AdvW : Type ; -- Adverb from DictEst (WordNet)

--2 Nouns

-- The worst case gives six forms.
-- In practice just a couple of forms are needed to define the different
-- stems, vowel alternation, and vowel harmony.

oper

-- The regular noun heuristic takes just one form (singular
-- nominative) and analyses it to pick the correct paradigm.
-- It does automatic grade alternation, and is hence not usable
-- for words like "auto" (whose genitive would become "audon").
--
-- If the one-argument paradigm does not give the correct result, one can try and give 
-- two or three forms. Most notably, the two-argument variant is used
-- for nouns like "kivi - kiviä", which would otherwise become like
-- "rivi - rivejä". Three arguments are used e.g. for 
-- "auto - auton - autoja", which would otherwise become
-- "auto - audon".

  mkN : overload {
    mkN : (kukko : Str) -> N ;  -- predictable nouns, covers 82%
    mkN : (savi,savia : Str) -> N ; -- different pl.part
    mkN : (vesi,veden,vesia : Str) -> N ; -- also different sg.gen
    mkN : (pank,panga,panka,panku : Str) -> N ; -- sg nom,gen,part, pl.part

--    mkN : (olo,n,a,na,oon,jen,ja,ina,issa,ihin : Str) -> N ; -- worst case, 10 forms
    mkN : (oun,ouna,ouna,ounasse,ounte,ounu : Str) -> N ; -- worst case, 6 forms
    mkN : (oun,ouna,ouna,ounasse,ounte,ounu,ountesse : Str) -> N ; -- worst case, 7 forms
    mkN : (pika : Str) -> (juna  : N) -> N ; -- compound with invariable prefix
    mkN : (oma : N)    -> (tunto : N) -> N ; -- compound with inflecting prefix
    mkN : NW -> N ;  -- noun from DictEst (WordNet)
  } ;

-- Nouns used as functions need a case, of which the default is
-- the genitive.

  mkN2 : overload {
    mkN2 : N -> N2 ;        -- relational noun with genitive
    mkN2 : N -> Prep -> N2  -- relational noun another prep.
    } ;

  mkN3  : N -> Prep -> Prep -> N3 ; -- relation with two complements

-- Proper names can be formed by using declensions for nouns.
-- The plural forms are filtered away by the compiler.

  mkPN : overload {
    mkPN : Str -> PN ;  -- predictable noun made into name
    mkPN : N -> PN      -- any noun made into name
    } ;

--2 Adjectives

-- Non-comparison one-place adjectives are just like nouns.
-- The regular adjectives are based on $regN$ in the positive.
-- Comparison adjectives have three forms. 
-- The comparative and the superlative
-- are always inflected in the same way, so the nominative of them is actually
-- enough (except for the superlative "paras" of "hyvä").

  mkA : overload {
    mkA : Str -> A ;  -- regular noun made into adjective
    mkA : N -> A ;    -- any noun made into adjective
    mkA : N -> (kivempi,kivin : Str) -> A ; -- deviating comparison forms
    mkA : (hyva,prmpi,pras : N) -> (hyvin,pmmin,prhten : Str) -> A ; -- worst case adj
    mkA : AW -> A ;  -- adjective from DictEst (WordNet)
  } ;

-- Two-place adjectives need a case for the second argument.

  mkA2 : A -> Prep -> A2  -- e.g. "jaollinen" casePrep adessive
    = \a,p -> a ** {c2 = p ; lock_A2 = <>};



--2 Verbs
--
-- The grammar does not cover the quotative mood and some nominal
-- forms. One way to see the coverage is to linearize a verb to
-- a table.
-- The worst case needs eight forms, as shown in the following.

  mkV : overload {
    mkV : (lugema : Str) -> V ;     -- predictable verbs, covers n %
    mkV : (huutaa,huusi : Str) -> V ; -- deviating past 3sg
    mkV : (huutaa,huudan,huusi : Str) -> V ; -- also deviating pres. 1sg
    mkV : (lugema,lugeda,loeb,loetakse : Str) -> V ;
    mkV : (tegema,teha,teeb,tehakse,tehke,tegi,teinud,tehtud : Str) -> V ; -- worst-case verb
    mkV : (saama : V) -> (aru : Str) -> V ; -- püsiühendid TODO
    mkV : VW -> V ;  -- verb from DictEst (WordNet)
  } ;

-- All the patterns above have $nominative$ as subject case.
-- If another case is wanted, use the following.

  caseV : Case -> V -> V ;  -- deviating subj. case, e.g. genitive "täytyä"

-- The verbs "be" and "go" are special.

  vOlema : V ; -- the verb "be"
  vMinema : V ; -- the verb "go"


--3 Two-place verbs
--
-- Two-place verbs need an object case, and can have a pre- or postposition.
-- The default is direct (accusative) object. There is also a special case
-- with case only. The string-only argument case yields a regular verb with
-- accusative object.

  mkV2 : overload {
    mkV2 : Str -> V2 ;  -- predictable direct transitive
    mkV2 : V -> V2 ;    -- direct transitive
    mkV2 : V -> Case -> V2 ; -- complement just case
    mkV2 : V -> Prep -> V2 ; -- complement pre/postposition
    } ;


--3 Three-place verbs
--
-- Three-place (ditransitive) verbs need two prepositions, of which
-- the first one or both can be absent.

  mkV3     : V -> Prep -> Prep -> V3 ;  -- e.g. puhua, allative, elative
  dirV3    : V -> Case -> V3 ;          -- siirtää, (accusative), illative
  dirdirV3 : V         -> V3 ;          -- antaa, (accusative), (allative)


--3 Other complement patterns
--
-- Verbs and adjectives can take complements such as sentences,
-- questions, verb phrases, and adjectives.

  mkV0  : V -> V0 ; --%
  mkVS  : V -> VS ;
  mkV2S : V -> Prep -> V2S ; -- e.g. "sanoa" allative
  mkVV  : V -> VV ;  -- e.g. "alkaa"
  mkVVf : V -> InfForm -> VV ; -- e.g. "hakkama" infMa
  mkV2V : V -> Prep -> V2V ;  -- e.g. "käskeä" genitive
  mkV2Vf : V -> Prep -> InfForm -> V2V ; -- e.g. "kieltää" partitive infMast  
  mkVA  : V -> Prep -> VA ; -- e.g. "maistua" ablative
  mkV2A : V -> Prep -> Prep -> V2A ; -- e.g. "maalata" accusative translative
  mkVQ  : V -> VQ ; 
  mkV2Q : V -> Prep -> V2Q ; -- e.g. "kysyä" ablative 

  mkAS  : A -> AS ; --%
  mkA2S : A -> Prep -> A2S ; --%
  mkAV  : A -> AV ; --%
  mkA2V : A -> Prep -> A2V ; --%

-- Notice: categories $AS, A2S, AV, A2V$ are just $A$, 
-- and the second argument is given
-- as an adverb. Likewise 
-- $V0$ is just $V$.

  V0 : Type ; --%
  AS, A2S, AV, A2V : Type ; --%

--.
-- The definitions should not bother the user of the API. So they are
-- hidden from the document.

  Case = MorphoEst.Case ;
  Number = MorphoEst.Number ;

  singular = Sg ;
  plural = Pl ;

  nominative = Nom ;
  genitive = Gen ;
  partitive = Part ;
  illative = Illat ;
  inessive = Iness ;
  elative = Elat ;
  allative = Allat ;
  adessive = Adess ;
  ablative = Ablat ;
  translative = Transl ;
  terminative = Termin ;
  essive  = Ess ;
  abessive = Abess ;  
  comitative = Comit ;
 
  infDa = InfDa ; infMa = InfMa ; infMast = InfMast ;
  --infDes = InfDes ; infMas = InfMas ; infMaks = InfMaks ; infMata = InfMata ;

  prePrep  : Case -> Str -> Prep = 
    \c,p -> {c = NPCase c ; s = p ; isPre = True ; lock_Prep = <>} ;
  postPrep : Case -> Str -> Prep =
    \c,p -> {c = NPCase c ; s = p ; isPre = False ; lock_Prep = <>} ;
  postGenPrep p = {
    c = NPCase genitive ; s = p ; isPre = False ; lock_Prep = <>} ;
  casePrep : Case -> Prep =
    \c -> {c = NPCase c ; s = [] ; isPre = True ; lock_Prep = <>} ;
  accPrep =  {c = NPAcc ; s = [] ; isPre = True ; lock_Prep = <>} ;

  NW = {s : NForms ; lock_NW : {}} ;
  AW = {s : NForms ; lock_AW : {}} ;
  VW = {s : VForms ; lock_VW : {}} ;
  AdvW = {s : Str ; lock_AdvW : {}} ;


  mkN = overload {
    mkN : (nisu : Str) -> N = mk1N ;
    --  \s -> nForms2N (nForms1 s) ;
    mkN : (talo,talon : Str) -> N = mk2N ;
    --  \s,t -> nForms2N (nForms2 s t) ;
    mkN : (talo,talon,taloja : Str) -> N = mk3N ;
    --  \s,t,u -> nForms2N (nForms3 s t u) ;

    mkN : (raamat,raamatu,raamatut,raamatuid : Str) -> N = mk4N ;

    mkN : (oun,ouna,ouna,ounasse,ounte,ounu : Str) -> N = mk6N ;

    mkN : (oun,ouna,ouna,ounasse,ounte,ounu,ountesse : Str) -> N = mk7N ;
--    mkN : 
--      (talo,talon,taloa,talona,taloon,talojen,taloja,taloina,taloissa,taloihin
--        : Str) -> N = mk10N ;
    mkN : (sora : Str) -> (tie : N) -> N = mkStrN ;
    mkN : (oma,tunto : N) -> N = mkNN ;
    mkN : (sana : NW) -> N = \w -> nForms2N w.s ;
  } ;

  -- Adjective forms (incl. comp and sup) are derived from noun forms
  mk1A : Str -> A = \jalo -> aForms2A (nforms2aforms (nForms1 jalo)) ;
  mkNA : N -> A = \suuri -> aForms2A (nforms2aforms (n2nforms suuri)) ;

  --mk1N : (talo : Str) -> N = \s -> nForms2N (nForms1 s) ;
  mk1N : (talo : Str) -> N = \s -> (hjk_type s) ** { lock_N = <> } ;
  mk2N : (talo,talon : Str) -> N = \s,t -> nForms2N (nForms2 s t) ;
  mk3N : (talo,talon,taloja : Str) -> N = \s,t,u -> nForms2N (nForms3 s t u) ;
  mk4N : (talo,talon,taloa,taloja : Str) -> N = \s,t,u,v -> 
      nForms2N (nForms4 s t u v) ;

  mk6N : (oun,ouna,ouna,ounasse,ounte,ounu : Str) -> N =
      \a,b,c,d,e,f -> (nForms6 a b c d e f) ** { lock_N = <> } ;
  mk7N : (oun,ouna,ouna,ounasse,ounte,ounu,ountesse : Str) -> N = 
      \a,b,c,d,e,f,g -> nForms2N (nForms7 a b c d e f g) ;


  mk10N : 
      (talo,talon,taloa,talona,taloon,talojen,taloja,taloina,taloissa,taloihin
        : Str) -> N = \a,b,c,d,e,f,g,h,i,j -> 
        nForms2N (nForms10 a b c d e f g h i j) ;


  mkStrN : Str -> N -> N = \sora,tie -> {
    s = \\c => sora + tie.s ! c ; lock_N = <>
    } ;
  mkNN : N -> N -> N = \oma,tunto -> {
    s = \\c => oma.s ! c + tunto.s ! c ; lock_N = <>
    } ; ---- TODO: oma in possessive suffix forms

  nForms1 : Str -> NForms = \ukko ->
    let
      ukk = init ukko ;
      uko = weaker ukko ;
      ukon = uko + "n" ;
      o = case last ukko of {"ä" => "ö" ; "a" => "o"} ; -- only used then 
      renka = stronger (init ukko) ;
      rake = stronger ukko ;
    in
    case ukko of {
      _ + "lik"        => dKasulik ukko ;
      _ + ("s"|"ne")   => dSoolane ukko ;
      _ => dSeminar ukko
    } ;   


  nForms2 : (_,_ : Str) -> NForms = \ukko,ukkoja -> 
      dNaine ukko  ;

  nForms3 : (_,_,_ : Str) -> NForms = \ukko,ukon,ukkoja -> 
      dOun ukko ;

  nForms4 : (_,_,_,_ : Str) -> NForms = \paat,paadi,paati,paate -> 
    case <paat,paadi,paati,paate> of {
      <_ + "ne", _+ "se", _+"st", _ + "si"> => dNaine paat ;
      <_ + "ne", _+ "se", _+"st", _ + "seid"> => dSoolane paat ;
      <_ + ("n"|"l"|"r"), _ + V@("a" | "u" | "e"),  _ + V,  _ + "u"> => dOun paat ; 
      <_ + C@("r" | "n" | "l" | "m" | "s" | "t" |"k"), _ + C + "i", 
       _ + C + "i", _> => dSeminar paat ;
      _  => dTuli paat paadi 
      } ;


  mkN2 = overload {
    mkN2 : N -> N2 = \n -> mmkN2 n (casePrep genitive) ;
    mkN2 : N -> Prep -> N2 = mmkN2
    } ;

  mmkN2 : N -> Prep -> N2 = \n,c -> n ** {c2 = c ; isPre = mkIsPre c ; lock_N2 = <>} ;
  mkN3 = \n,c,e -> n ** {c2 = c ; c3 = e ; 
    isPre = mkIsPre c  ; -- matka Lontoosta Pariisiin
    isPre2 = mkIsPre e ;          -- Suomen voitto Ruotsista
    lock_N3 = <>
    } ;
  
  mkIsPre : Prep -> Bool = \p -> case p.c of {
    NPCase Gen => notB p.isPre ;  -- Jussin veli (prep is <Gen,"",True>, isPre becomes False)
    _ => True                     -- syyte Jussia vastaan, puhe Jussin puolesta
    } ;

  mkPN = overload {
    mkPN : Str -> PN = mkPN_1 ;
    mkPN : N -> PN = \s -> {s = \\c => s.s ! NCase Sg c ; lock_PN = <>} ;
    } ;

  mkPN_1 : Str -> PN = \s -> {s = \\c => (mk1N s).s ! NCase Sg c ; lock_PN = <>} ;

-- adjectives

  mkA = overload {
    mkA : Str -> A  = mkA_1 ;
    mkA : N -> A = \n -> noun2adjDeg n ** {lock_A = <>} ;
    mkA : N -> (kivempaa,kivinta : Str) -> A = regAdjective ;
    mkA : (sana : AW) -> A = \w -> noun2adjDeg (nForms2N w.s) ;

--    mkA : (hyva,parempi,paras : N) -> (hyvin,paremmin,parhaiten : Str) -> A ;
  } ;

  mkA_1 : Str -> A = \x -> noun2adjDeg (mk1N x) ** {lock_A = <>} ;

-- auxiliaries
  mkAdjective : (_,_,_ : Adj) -> A = \hyva,parempi,paras -> 
    {s = table {
      Posit  => hyva.s ;
      Compar => parempi.s ;
      Superl => paras.s
      } ;
     lock_A = <>
    } ;
  regAdjective : Noun -> Str -> Str -> A = \kiva, kivempi, kivin ->
    mkAdjective 
      (noun2adj kiva) 
      (noun2adjComp False (nForms2N (dSuurempi kivempi))) 
      (noun2adjComp False (nForms2N (dSuurin kivin))) ;

  -- TODO: this is a bit simplified
  -- http://www.eki.ee/books/ekk09/index.php?p=3&p1=4&id=208
  -- TODO: maybe not implement the superlative, which is more complex,
  -- use "kõige" + Comp instead
  noun2adjDeg : Noun -> Adjective = \suur ->
    regAdjective
      suur
      ((suur.s ! NCase Sg Gen) + "m")
      ((suur.s ! NCase Sg Gen) + "im") ;


-- verbs

  mkV = overload {
    mkV : (huutaa : Str) -> V = mk1V ;
    mkV : (huutaa,huusi : Str) -> V = mk2V ;
    mkV : (huutaa,huudan,huusi : Str) -> V = mk3V ;
    mkV : (lugema,lugeda,loeb,loetakse : Str) -> V = mk4V ;
    mkV : (tegema,teha,teeb,tehakse,tehke,tegi,teinud,tehtud : Str) -> V = mk8V ;
    mkV : (aru : Str) -> (saama : V) -> V = mkPV ; -- particle verbs
    mkV : (sana : VW) -> V = \w -> vforms2V w.s ** {sc = NPCase Nom ; lock_V = <>} ;
  } ;

  mk1V : Str -> V = \s -> 
    let vfs = vforms2V (vForms1 s) in 
      vfs ** {sc = NPCase Nom ; lock_V = <>} ;
  mk2V : (_,_ : Str) -> V = \x,y -> 
    let vfs = vforms2V (vForms2 x y) in vfs ** {sc = NPCase Nom ; lock_V = <>} ;
  mk3V : (huutaa,huudan,huusi : Str) -> V = \x,_,y -> mk2V x y ; ----
  mk4V : (lugema,lugeda,loeb,loetakse : Str) -> V =
     \a,b,c,d -> mk_forms4_to_verb (vForms4 a b c d) ** {sc = NPCase Nom ; lock_V = <>} ;
  mk8V : (lugema,lugeda,loeb,loetakse,lugege,luges,lugenud,loetud : Str) -> V =
     \a,b,c,d,e,f,g,h -> vforms2V (vForms8 a b c d e f g h) ** {sc = NPCase Nom ; lock_V = <>} ;
  mkPV : (aru : Str) -> (saama : V) -> V = \aru,saama ->
    {s = saama.s ; s2 = aru ; sc = saama.sc ; lock_V = <> } ;
     
  	
  -- This used to be the last case: _ => Predef.error (["expected infinitive, found"] ++ ottaa) 
  -- regexp example: ("" | ?) + ("a" | "e" | "i") + _ + "aa" => 
  vForms1 : Str -> VForms = \lugema ->
    let
      luge = Predef.tk 2 lugema ;
      loe = weaker luge ;
      v : pattern Str = #("a" | "e" | "i" | "o" | "u" | "õ" | "ä" | "ö" | "ü") ;
      c : pattern Str = #("m" | "n" | "p" | "b" | "t" | "d" | "k" | "g" | "f" | "v" | "s" | "h" | "l" | "j" | "r" | "z" | "ž" | "š") ;
      lmnr : pattern Str = #("l" | "m" | "n" | "r") ;
      kpt : pattern Str = #("k" | "p" | "t" | "f" | "š") ;
    in
    case lugema of {
      -- TS 49
      -- Small class of CVVma
      ? + ("ä"|"õ"|"i") + "ima" =>
        cKaima lugema ;  --käima,viima,võima
      ? + ("aa"|"ee"|"ää") + "ma" =>  
        cSaama lugema ;  -- saama,jääma,keema
      ? + ("oo"|"öö"|"üü") + "ma" =>
        cJooma lugema ;  --jooma,looma,lööma,müüma,pooma,sööma,tooma

      -- TS 53
      _ + "elema" =>
        cTegelema lugema ;
      
      -- TS 54
      -- Small class, just list all members
      ("tule"|"sure"|"pane") + "ma" =>
        cTulema lugema ;
        
      -- TS 55-57
      -- Consonant gradation
      _ + ("kk"|"pp"|"tt"|"ss") + "ima" => --TODO not a complete list
        cLeppima lugema ;
      ? + "ugema" => --lugema,pugema,sugema ; not raugema
        cLeppima lugema ;
      ("pidama"|"siduma") => --only these two (?)
        cLeppima lugema ;
      
      -- TS 60 (jätma,võtma) default behaviour for CVtma, based on frequency.
      ? + #v + "tma" =>
        cJatma lugema ;        
      -- TS 59 (lõpma,tapma). Rest (nutma,petma,utma) with mk2V/mk3V (TODO). 
      ? + #v + "pma" =>
        cPetma lugema ;
      -- TS 58 for rest that end tma (muutma,kartma,...)
      _ + "tma" =>
        cMuutma lugema ;

     -- TS 61 (laulma,kuulma,naerma,möönma)
     -- Default vowel e for lma, a for (r|n)ma.
     -- For laulab use mk2V/mk3V (TODO).
      _ + "lma" => 
        cKuulma lugema (loe + "eb") ; 
      _ + ("r"|"n") + "ma" =>
        cKuulma lugema (loe + "ab") ;
     
      -- TS 63 (andma,hoidma)
      _ + "dma" =>
        cAndma lugema ;
        
      -- TS 62 alt form
      _ + "ooksma" => --for any other verb that would need jooksma~joosta~jookseb, mk2V
        cJooksma lugema ;
        
      -- TS 62, 64 (tõusma,mõskma), default vowel e 
      _ + #c + "ma" => 
        cLaskma lugema (loe + "eb") ; --for __ab use mk2V/mk3V (TODO)
        
      -- TS 65 (pesema)
      #c + #v + "sema" =>
        cPesema lugema ;
        
      -- TS 66 (nägema)
      -- Small class, just list all members
      ("nägema"|"tegema") =>
        cNagema lugema ;
      
     -- TS 67-68
     (?|"") + ? + ("n"|"r") + "dama" => --hindama,kordama; not alandama
        cHyppama lugema ;
     (?|"") + ? + ("h"|"s"|"n") + "tama" => --istama,kohtama; not armastama 
        cHyppama lugema ;
     _ + #lmnr + ("k"|"p"|"g"|"b"|"j"|"v") + "ama" => --hingama,põrkama,arvama
        cHyppama lugema ;
     _ + ("sk"|"ps"|"ks"|"ts"|"pl") + "ama" => --oskama,jaksama
        cHyppama lugema ;
     _ + ("hk"|"hm"|"hn"|"hr") + "ama" => --puhkama,lõhnama 
        cHyppama lugema ;
     _ + ("pp"|"kk"|"tt"|"ss"|"nn"|"mm"|"ll"|"rr") + "ama" => --hakkama
        cHyppama lugema ;
     ? + ("aa"|"oo"|"uu") + ("d"|"t") + "ama" => --ootama,vaatama
        cHyppama lugema ;
      
      -- TS 69
      _ + #c + "lema" =>
        cOmblema lugema ;

      -- TS 50-52
      -- Default case
      _ =>
        cElama lugema
        
{-      _ + ("a" | "e" | "i" | "o" | "u") + ("ta" | "sta" | "bi") + "ma" =>
        cElama lugema ;
      _ + ("a" | "e" | "u" | "i") + "ma" =>
        cElama lugema ; 
-}
    } ;   
 
  vForms2 : (_,_ : Str) -> VForms = \petma,petta ->
    let
      pet = Predef.tk 2 petma ;
      pett = Predef.tk 2 petta
    in 
    case <petma,petta> of {
      <_, _ + ("tt"|"kk"|"pp") + _> => cPetma petma ;
      <_ + "ksma", _ + "sta"> => cJooksma petma ;
      _ => vForms1 petma
      } ;

  caseV c v = {s = v.s ; s2 = v.s2; sc = NPCase c ; lock_V = <>} ;

  vOlema = verbOlema ** {sc = NPCase Nom ; lock_V = <>} ;
  vMinema = verbMinema ** {sc = NPCase Nom ; lock_V = <>} ;

  mk2V2 : V -> Prep -> V2 = \v,c -> v ** {c2 = c ; lock_V2 = <>} ;
  caseV2 : V -> Case -> V2 = \v,c -> mk2V2 v (casePrep c) ; 
  dirV2 v = mk2V2 v accPrep ;

  mkAdv = overload { 
    mkAdv : Str -> Adv = \s -> {s = s ; lock_Adv = <>} ;
    mkAdv : AdvW -> Adv = \s -> {s = s.s ; lock_Adv = <>} ;
    } ;

  mkV2 = overload {
    mkV2 : Str -> V2 = \s -> dirV2 (mk1V s) ;
    mkV2 : V -> V2 = dirV2 ;
    mkV2 : V -> Case -> V2 = caseV2 ;
    mkV2 : V -> Prep -> V2 = mk2V2 ;
    } ;

  mk2V2 : V -> Prep -> V2 ;
  caseV2 : V -> Case -> V2 ;
  dirV2 : V -> V2 ;

  mkV3 v p q = v ** {c2 = p ; c3 = q ; lock_V3 = <>} ; 
  dirV3 v p = mkV3 v accPrep (casePrep p) ;
  dirdirV3 v = dirV3 v allative ;

  mkVS  v = v ** {lock_VS = <>} ;
  mkVV  v = mkVVf v infDa ;
  mkVVf  v f = v ** {vi = f ; lock_VV = <>} ;
  mkVQ  v = v ** {lock_VQ = <>} ;

  V0 : Type = V ;
  AS, A2S, AV : Type = A ;
  A2V : Type = A2 ;

  mkV0  v = v ** {lock_V = <>} ;
  mkV2S v p = mk2V2 v p ** {lock_V2S = <>} ;
  mkV2V v p = mkV2Vf v p infMa ;
  mkV2Vf v p f = mk2V2 v p ** {vi = f ; lock_V2V = <>} ;

  mkVA  v p = v ** {c2 = p ; lock_VA = <>} ;
  mkV2A v p q = v ** {c2 = p ; c3 = q ; lock_V2A = <>} ;
  mkV2Q v p = mk2V2 v p ** {lock_V2Q = <>} ;

  mkAS  v = v ** {lock_A = <>} ;
  mkA2S v p = mkA2 v p ** {lock_A = <>} ;
  mkAV  v = v ** {lock_A = <>} ;
  mkA2V v p = mkA2 v p ** {lock_A2 = <>} ;

} ;
