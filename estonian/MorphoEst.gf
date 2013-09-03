--# -path=.:../common:../prelude

--1 A Simple Estonian Resource Morphology
--
-- Aarne Ranta (, Inari Listenmaa, Kaarel Kaljurand)
--
-- This resource morphology contains definitions needed in the resource
-- syntax. To build a lexicon, it is better to use $ParadigmsEst$, which
-- gives a higher-level access to this module.

resource MorphoEst = ResEst ** open Prelude, HjkEst in {

  flags optimize=all ; coding=utf8;

  oper
  --Estonian paradigms

  --Inflection paradigms from tüüpsõnad 

  --1: stem vowel in nom, regular endings, concatenative
  -- can combine with 7, only difference is sg.part
  -- can combine with 2, only difference is pl.part
  -- (but maybe not with both)
  dKoi : Str -> NForms = \koi ->
    nForms7
      koi koi (koi + "d") (koi + "sse")            -- sg nom, gen, part, ill
      (koi + "de") (koi + "sid") (koi + "desse") ; -- pl      gen, part, ill


  --2: like 1, but pl.part irregular.
  dLuu : Str -> NForms = \luu ->
    let 
      lui = (Predef.tk 1 luu) + "i" ;
    in nForms7
      luu luu (luu + "d") (luu + "sse")
      (luu + "de") (lui + "d") (luu + "desse") ;


  --3: sg nom,gen,part identical. non-predictable vowel in pl.part.
  dPesa : (_,_ : Str) -> NForms = \pesa,pesi ->
    nForms7
      pesa pesa pesa (pesa + "sse")         -- sg nom, gen, part, ill
      (pesa + "de") pesi (pesa + "desse") ; -- pl      gen, part, ill


  --4: i-e change, sg.part has e (suvi-suve-suve).
  --5: i-e change, sg.part has d (tuli-tule-tuld).
  --   sg.part needed to distinguish between tuld and suve.
  dTuli : (_,_ : Str) -> NForms = \tuli,tuld ->
    let
      tule  : Str = Predef.tk 1 tuli + "e" 
    in nForms7
      tuli tule tuld (tule + "sse")
      (tule + "de") (tule + "sid") (tule + "desse") ;

  --6: loan words, stem vowel always i, sg.nom ends in consonant
  dSeminar : Str -> NForms = \seminar ->
    let
      seminari = seminar + "i" ; 
    in nForms7
      seminar seminari seminari (seminari + "sse")
      (seminari + "de") (seminari + "sid") (seminari + "desse") ; -- pl gen, part, ill

  --7: stem vowel in sg nom, -t in sg part
  dRatsu : Str -> NForms = \ratsu ->
    nForms7
      ratsu ratsu (ratsu + "t") (ratsu + "sse")
      (ratsu + "de") (ratsu + "sid") (ratsu + "desse") ;

  --8: sg.gen not predictable:  õpik-õpiku,  ohutu-ohutu  or kindel-kindla
  --   pl.part is just concatenated, no stem changes
  dKindel : (_,_ : Str) -> NForms = \kindel,kindla ->
    nForms7
      kindel kindla (kindla + "t") (kindla + "sse")
      (kindla + "te") (kindla + "id") (kindla + "tesse");

  --9: like 8, e.g. redel-redeli, väeti-väeti  or  number-numbri
  --   stem vowel changes in pl.part: i-eid
  dNumber : (_,_ : Str) -> NForms = \number,numbri ->
    let
      numbr = Predef.tk 1 numbri --the consonant stem
    in nForms7
      number numbri (numbri + "t") (numbri + "sse")
      (numbri + "te") (numbr + "eid") (numbri + "tesse") ;

  --10: ase-aseme-aset ; -me in stem, not in sg.nom and sg.part
  dAse : Str -> NForms = \ase ->
    let
      aseme : Str = ase + "me"
    in nForms7
      ase aseme (ase + "t") (aseme + "sse")
      (aseme + "te") (aseme + "id") (aseme + "tesse") ; 

  --11: like 13, but vowel insertion. Covered in 13.

  --12: -se in stem, pl.part -si
  --     sg.nom can be -ne or -s (oluline ; peegeldus)
  -- Kaarel/2011-11-17: added "match all" because otherwise got a linking error
  dNaine : Str -> NForms = \naine ->
    let 
      nais : Str = case naine of {
        _ + "ne" => Predef.tk 2 naine + "s" ;
        _ + "s"  => naine ;  -- if nominative ends in s already
        _        => naine    -- match all
      } 
    in nForms7
      naine (nais + "e") (nais + "t") (nais + "esse")
      (nais + "te") (nais + "i") (nais + "tesse") ; -- pl gen, part, ill
 
  --13: -se in stem, pl.part -eid
  --     soolane, tehas as in 12. vowel insertion in raudne-raudse-raudset.
  -- Kaarel/2011-11-17: added "match all" because otherwise got a linking error
  dSoolane : Str -> NForms = \soolane ->
    let 
      soolas : Str = case soolane of {
        _ + "ne" => Predef.tk 2 soolane + "s" ;
        _ + "s"  => soolane ;
        _        => soolane
      } ;
      raudse : Str = case soolas of {
        _ + ("r"|"l"|"d"|"t"|"m"|"p"|"k"|"g") + "s"  => soolas +"e" ;
        _ => soolas
      }
    in nForms7
      soolane (soolas + "e") (raudse + "t") (soolas + "esse")
      (raudse + "te") (soolas + "eid") (raudse + "tesse") ; -- pl gen, part, ill

  --14 and 15 are covered in 12 and 13. 

  --16: rida-rea

  --17: jogi-joe

  --18: nali-nalja; sober-sobra-sopra. consonant gradation and other stuff.

  --19: -lik-liku-likku
  dKasulik : Str -> NForms = \kasulik ->
    nForms7
      kasulik (kasulik + "u") (kasulik + "ku") (kasulik + "usse")
      (kasulik + "e") (kasulik + "ke") (kasulik + "esse") ;


  --20: stem vowel not predictable. e in pl.part.
  --dPaks : (_,_ : Str) -> NForms = \paks,paksu ->
  --kabinet', kabineti, kabi.netti, kabi.netti ja kabinetisse, kabi.nettide, kabi.net'te (ja 
  --kabi.nettisid), kabi.nettidesse ja  kabinet'esse
  -- vs. sepp-sepa-seppa. Maybe some kind of regexp "if V+C@(p|t|k) in nom, treat as V+C+C"

  --21: like 20, i in pl.part.
  --dTaht : (_,_ : Str) -> NForms = \taht,tahe ->

  --22: like 20, u in pl.part.
  --dLeib : (_,_ : Str) -> NForms = \leib,leiva ->

  --23:	sai, saia, .saia, .saia ja saiasse, .saiade, .saiu ja .saiasid, .saiadesse ja saiusse
  --    like 20-22, but sg.nom ends in vowel
  --20-23 could also be one oper that takes sg.nom, sg.gen and pl.part


  --24: pood-poe-poodi. seems irregular, implement later.

  --25: oun-ouna, pl.gen -te instead of -de. Might have some gradation, not yet implemented.
  dOun : Str -> NForms = \oun ->
    let 
      ouna = oun + "a" ;
    in nForms7
      oun ouna ouna (ouna + "sse")
      (oun + "te") (oun + "u") (oun + "tesse") ; -- pl gen, part, ill

  --26: käsi-käe-kätt

  --27: uus-uue-uut ; 28: vars-varre-vart ; 29: kaas-kaane-kaant ; 30: suur-suure-suurt
  --distinctive features for 2-place mkN: sg nom and gen
  --default case for noun ending in s probably dSoolane?
  dKaas : (_,_ : Str) -> NForms = \kaas,kaane ->
    let
      kaan : Str = Predef.tk 1 kaane ;
      var  : Str = case kaan of {
        _ + ("ll"|"rr"|"nn")  => Predef.tk 1 kaan ; -- V@? + C@? + C 
        _ => kaan  
      }
    in nForms7
      kaas (kaan + "e") (var + "t") (kaan + "esse")
      (var + "te") (kaas + "i") (var + "tesse") ;

  --31: mote-motte, hinne-hinde. reverse consonant gradation, stem vowel in sg.nom.
  dHinne : Str -> NForms = \hinne ->
    let
      hinde : Str = strongGrade hinne 
    in nForms7
      hinne hinde (hinne + "t") (hinde + "sse")
      (hinne + "te") (hinde + "id") (hinne + "tesse") ;

  --32: ranne-randme, paase-paasme
  -- like 10, but -me is added to consonant stem.
  -- as a side effect, consonant gradation is handled too by giving sg.nom and sg.gen
  -- diff between 10 and 32: whether (ranne == Predef.tk 2 randme)?
  dRanne : (_,_ : Str) -> NForms = \ranne,randme ->
    let
      rand : Str = Predef.tk 2 randme 
    in nForms7
      ranne randme (ranne + "t") (randme + "sse")
      (randme + "te") (randme + "id") (randme + "tesse") ;

  --33: ratas-ratta-ratast 34: rukis-rukki-rukist 35: armas-armsa-armast

  --36: torges-torksa-torksat~torgest (sober-sobra-sopra? number-numbri-numbrit?)
  --37: kyynel-kyynla-kyynelt
  --38: aken-akna-akent.

  
-- Finnish paradigms, here only for not to break ParadigmsEst

-- for adjective comparison

  -- Comparative adjectives inflect in the same way
  -- TODO: confirm this
  dSuurempi : Str -> NForms = \suurem ->
    let
      suurema = suurem + "a" ;
    in nForms7
      suurem (suurema) (suurema + "t") (suurema + "sse")
      (suurema + "te") (suurema + "id") (suurema + "tesse") ;

  -- Superlatives follow the exact same pattern as comparatives
  -- TODO: confirm this
  dSuurin : Str -> NForms = \suurim -> dSuurempi suurim ;


-------------------
-- auxiliaries ----
-------------------

-- the maximal set of technical stems

    NForms : Type = Predef.Ints 6 => Str ;

    --Estonian
    nForms7 : (x1,_,_,_,_,_,x7 : Str) -> NForms = 
      \jogi,joe,joge,joesse, -- sg nom, gen, part, ill
       jogede,jogesid,jogedesse -> table { -- pl gen, part, ill
      0 => jogi ;
      1 => joe ;
      2 => joge ;
      3 => joesse ;
      4 => jogede ;
      5 => jogesid ;
      6 => jogedesse
      } ;

  n2nforms : Noun -> NForms = \ukko -> table {
    0 => ukko.s ! NCase Sg Nom ;
    1 => ukko.s ! NCase Sg Gen ;
    2 => ukko.s ! NCase Sg Part ;
    3 => ukko.s ! NCase Sg Illat ;
    4 => ukko.s ! NCase Pl Gen ;
    5 => ukko.s ! NCase Pl Part ;
    6 => ukko.s ! NCase Pl Illat
  } ;
  --end Estonian
    Noun = {s : NForm => Str; lock_N : {}} ;

    nForms2N : NForms -> Noun = \f -> 
      let
        jogi = f ! 0 ;
        joe = f ! 1 ;
        joge = f ! 2 ;
        joesse = f ! 3 ;
        jogede = f ! 4 ;
        jogesid = f ! 5 ;
        jogedesse = f ! 6 ;
      in 
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
      NCase Pl Illat  => jogedesse ;
      NCase Pl Adess  => jogede + "l" ;
      NCase Pl Ablat  => jogede + "lt" ;
      NCase Pl Allat  => jogede + "le" ;
      NCase Pl Abess  => jogede + "ta" ;
      NCase Pl Comit  => jogede + "ga" ;
      NCase Pl Termin => jogede + "ni" 

      } ;
    lock_N = <>
    } ;

    -- not needed, just for not breaking things now
    NFormsFin : Type = Predef.Ints 9 => Str ;

    nForms10 : (x1,_,_,_,_,_,_,_,_,x10 : Str) -> NFormsFin = 
      \jogi,joe,joge,joena,joesse, -- sg nom, gen, part, ess, ill
       jogede,jogesid,jogedena,jogedes,jogedesse -> table { -- pl gen, part, ess, ine, ill
      0 => jogi ;
      1 => joe ;
      2 => joge ;
      3 => joena ;
      4 => joesse ;
      5 => jogede ;
      6 => jogesid ;
      7 => jogedena ;
      8 => jogedes ;
      9 => jogedesse
      } ;


-- Adjective forms

    AForms : Type = {
      posit  : NForms ;
      compar : NForms ;
      superl : NForms ;
      adv_posit, adv_compar, adv_superl : Str ;
      } ;

    aForms2A : AForms -> Adjective = \afs -> {
      s = table {
        Posit => table {
          AN n => (nForms2N afs.posit).s ! n ; 
          AAdv => afs.adv_posit
          } ;
        Compar => table {
          AN n => (nForms2N afs.compar).s ! n ; 
          AAdv => afs.adv_compar
          } ;
        Superl => table {
          AN n => (nForms2N afs.superl).s ! n ; 
          AAdv => afs.adv_superl
          }
        } ;
      lock_A = <>
      } ;

    nforms2aforms : NForms -> AForms = \nforms -> 
      let
        suure = init (nforms ! 1) ;
        suur = Predef.tk 4 (nforms ! 8) ;
      in {
        posit = nforms ;
        compar = dSuurempi (suure ++ "m") ;
        superl = dSuurin   (suur ++ "im") ;
        adv_posit = suure + "sti" ;
        adv_compar = suure + "mmin" ;
        adv_superl = suur + "immin" ;
      } ;

---------------------
-- Verb morphology --
---------------------

oper
  -- TS 49
  -- d in da, takse, dud ; imperfect 3sg ends in i
  cSaama : (_ : Str) -> VForms = \saama ->
    let
      saa = Predef.tk 2 saama ;
      sa = Predef.tk 1 saa ;
      sai = sa + "i" ;
    in vForms8
      saama
      (saa + "da")
      (saa + "b")
      (saa + "dakse") 
      (saa + "ge") -- Imper Pl
      sai
      (saa + "nud") 
      (saa + "dud") ;

  -- TS 49
  -- no d/t in da, takse ; imperfect 3sg ends in s
  cKaima : (_ : Str) -> VForms = \kaima ->
    let
      kai = Predef.tk 2 kaima ;      
    in vForms8
      kaima
      (kai + "a")
      (kai + "b")
      (kai + "akse")
      (kai + "ge")
      (kai + "s")
      (kai + "nud") 
      (kai + "dud") ;

  -- TS 49 
  -- vowel changes in -da da, takse, no d/t ; imperfect 3sg ends in i
  cJooma : (_ : Str) -> VForms = \jooma ->
    let
      j = Predef.tk 4 jooma ;
      joo = Predef.tk 2 jooma;
      o = last joo ;
      u = case o of {
        "o" => "u" ;
        "ö" => "ü" ;
         _  => o 
        } ;
      q = case o of {
        ("o"|"ö") => "õ" ;
         _        => o
        } ;
       juua = j + u + u + "a" ;
       j6i = j + q + "i" ;
    in vForms8
      jooma
      juua
      (joo + "b")
      (juua + "kse")
      (joo + "ge") 
      j6i
      (joo + "nud") 
      (joo + "dud") ;

  -- TS 50-53 (elama, muutuma, kirjutama, tegelema alt forms)
  -- t in takse, tud, no cons.grad
  cElama : (_ : Str) -> VForms = \elama ->
    let
      ela = Predef.tk 2 elama;
    in vForms8
      elama
      (ela + "da")
      (ela + "b")
      (ela + "takse") 
      (ela + "ge") -- Imperative P1 Pl
      (ela + "s")  -- Imperfect P3 Sg 
      (ela + "nud") 
      (ela + "tud") ;

  --TS 54 (tulema)
  --consonant assimilation on l,r,n
  --cTulema : (_ : Str) -> VForms = \tulema ->
  --  let
  --  in
  --    vForms8
  
  -- TS 55-57 (õppima, sündima, lugema)
  -- t in takse, tud ; consonant gradation on stem
  cLeppima : (_ : Str) -> VForms = \leppima ->
    let
      leppi = Predef.tk 2 leppima ;
      i = last leppi ;
      lepp = init leppi ;
      lepi = (weaker lepp) + i ;
    in vForms8
      leppima
      (leppi + "da")
      (lepi + "b")
      (lepi + "takse")
      (leppi + "ge") -- Imperative P1 Pl
      (leppi + "s")  -- Imperfect P3 Sg
      (leppi + "nud")
      (lepi + "tud") ;
      
      
  -- TS 58 muutma, saatma,
  -- like laskma (TS 62, 64), but no reduplication of stem consonant (muutma~muuta, not *muutta)
  -- like andma (TS 63) but different takse (muudetakse vs. antakse)
  cMuutma : (_ : Str) -> VForms = \muutma ->
    let
      muut = Predef.tk 2 muutma ;
      muud = weaker muut ;
    in vForms8
      muutma
      (muut + "a")
      (muud + "ab")
      (muud + "etakse") -- always e?
      (muut + "ke")
      (muut + "is")
      (muut + "nud")
      (muud + "etud") ; -- always e?
  
  -- TS 59 (petma), TS 60 (jatma)
  -- weak stem in ma, strong in da ; TS 60 irregular takse, tud
  -- tud given as a param
  cJatma : (_,_ : Str) -> VForms = \jatma,jaetud ->
    let
      jat = Predef.tk 2 jatma ;
      jatt = stronger jat ;
      jaet = Predef.tk 2 jaetud ;
    in vForms8
      jatma
      (jatt + "a")
      (jat + "ab")
      (jaet + "akse") --always e?
      (jat + "ke")
      (jatt + "is")
      (jat + "nud")
      jaetud ; --always e?
      
      
  --TS 61 (laulma)
  --vowel given with the second param
  --veenma,naerma
  cKuulma : (_,_ : Str) -> VForms = \kuulma,kuuleb ->
    let
      kuul = Predef.tk 2 kuulma ;
    in vForms8
      kuulma
      (kuul + "da")
      kuuleb
      (kuul + "dakse")
      (kuul + "ge")
      (kuul + "is")
      (kuul + "nud")
      (kuul + "dud") ;
      
  --TS 62 (tõusma), 64 (mõksma)
  --works also for maitsma, jooksma
  --doesn't give alt. forms joosta, joostes
  cLaskma : (_,_ : Str) -> VForms = \laskma,laseb ->
    let
      lask = Predef.tk 2 laskma ;
      las = weaker lask ; --no effect on tõusma
      
    in vForms8
      laskma
      (las + "ta")
      laseb
      (las + "takse")
      (las + "ke")
      (lask + "is")
      (lask + "nud") 
      (las + "tud") ;

  -- TS 63 (andma, murdma, hoidma) 
  cAndma : (_ : Str) -> VForms = \andma ->
    let
      and = Predef.tk 2 andma ; --murd(ma), hoid(ma)
      an = Predef.tk 1 and ;    --mur(d),   hoi(d)
      ann = weaker and ;        --murr,     hoi
    in vForms8
      andma
      (and + "a")
      (ann + "ab")
      (an + "takse")
      (and + "ke")
      (and + "is")
      (and + "nud")
      (an + "tud") ;
      
  -- TS 65 (pesema)
  -- a consonant stem verb in disguise
  cPesema : (_ : Str) -> VForms = \pesema ->
    let
      pese = Predef.tk 2 pesema ;
      pes =  Predef.tk 1 pese ;
    in vForms8
      pesema
      (pes + "ta")
      (pese + "b")
      (pes + "takse")
      (pes + "ke")
      (pes + "i")
      (pes + "nud")
      (pes + "tud") ;

  -- TS 66 (nägema)
  -- very irregular
  -- TODO
  cNagema : (_ : Str) -> VForms = \nagema ->
    let
      nage = Predef.tk 2 nagema ;
      nag =  Predef.tk 1 nage ;
      na = tk 1 nag ;
      nah = na + "h" ;
      nai = na + "i" ;
    in vForms8
      nagema
      (nah + "a")
      (nage + "b")
      (nah + "akse")
      (nah + "ke")
      (nag + "i")
      (nai + "nud")
      (nah + "tud") ;
  
  
      
  -- TS 67-68 (hüppama, tõmbama) 
  -- strong stem in ma, b, s
  -- weak stem in ta, takse, ke, nud, tud
  cHyppama : (_ : Str) -> VForms = \hyppama ->
    let
      hyppa = Predef.tk 2 hyppama ;
      hypa = weaker hyppa ;
    in vForms8
      hyppama
      (hypa + "ta")
      (hyppa + "b")
      (hypa + "takse") -- Passive
      (hypa + "ke") -- Imperative P1 Pl
      (hyppa + "s") -- Condit Sg P3
      (hyppa + "nud") -- PastPartAct
      (hypa + "tud") ; -- PastPartPass

  -- TS 69 (õmblema)
  cOmblema : (_ : Str) -> VForms = \omblema ->
    let
      omble = Predef.tk 2 omblema ;
      e = last omble ;
      l = last (Predef.tk 1 omble) ;
      omb = Predef.tk 2 omble ;
      ommel = (weaker omb) + e + l ;
    in vForms8
      omblema
      (ommel + "da")
      (omble + "b")
      (ommel + "dakse") -- Passive
      (ommel + "ge") -- Imperative P1 Pl
      (omble + "s") -- Condit Sg P3
      (omble + "nud") -- PastPartAct
      (ommel + "dud") ; -- PastPartPass
  
  
{-- TS 58 (saatma), 63 (murdma)
  -- Strong stem in ma and da 
  -- Needs tud as a parameter, takse formed from that
  -- This might make sense with 2-param constructor. Not deleting yet. 
  -- cMuutma for only 58 and cAndma for only 63.
  cSaatma5863 : (_,_ : Str) -> VForms = \saatma,saadetud ->
    let
      saat = Predef.tk 2 saatma ;
      saadet = Predef.tk 2 saadetud ;
      murtakse = saadet + "akse" ;  
      saad = weaker saat ;
    in
      vForms8
        saatma
        (saat + "a")
        (saad + "ab")
        murtakse
        (saat + "ke")
        (saat + "is")
        (saat + "nud")
        saadetud ;
-}  
  
  regVerb : (_,_,_,_ : Str) -> Verb = \kinkima,kinkida,kingib,kingitakse ->
    mk_forms4_to_verb (vForms4 kinkima kinkida kingib kingitakse) ;

-- auxiliaries

    -- TODO: does not exist in Estonian
    uyHarmony : Str -> Str = \a -> case a of {
      "a" => "u" ;
      _ => "y"
      } ;

    VForms : Type = Predef.Ints 7 => Str ;

    VForms4 : Type = Predef.Ints 3 => Str ;
    
    vForms8 : (x1,_,_,_,_,_,_,x8 : Str) -> VForms =
      \tulema,tulla,tuleb,tullakse,tulge,tuli,tulnud,tuldud ->
      table {
        0 => tulema ;
        1 => tulla ;
        2 => tuleb ;
        3 => tullakse ;
        4 => tulge ;
        5 => tuli ;
        6 => tulnud ;
        7 => tuldud
      } ;

    vforms2V : VForms -> Verb = \vh -> 
    let
      tulema = vh ! 0 ; 
      tulla = vh ! 1 ; 
      tuleb = vh ! 2 ; 
      tullakse = vh ! 3 ; --juuakse; loetakse 
      tulge = vh ! 4 ;  --necessary for tulla, surra (otherwise *tulege, *surege) 
      tuli = vh ! 5 ; --necessary for jooma-juua-jõi
      tulnud = vh ! 6 ;
      tuldud = vh ! 7 ; --necessary for t/d in tuldi; loeti
      
      tull_ = Predef.tk 1 tulla ; --juu(a); saad(a); tull(a);
      tulles = tull_ + "es" ; --juues; saades; tulles;
      
      tule_ = init tuleb ;
      
      lask_ = Predef.tk 2 tulema ;
      laulev = case (last lask_) of { --sooma~soov ; laulma~laulev
          ("a"|"e"|"i"|"o"|"õ"|"u"|"ü"|"ä"|"ö") => lask_ + "v" ;
          _ => lask_ + "ev" } ; --consonant stem in -ma, add e
          
      --imperfect stem
      kaisi_ = case (Predef.dp 3 tuli) of {
          "sis"    => lask_ + "i" ; --tõusin, tõusis
          _ + "i"  => tuli ;        --jõin, jõi
          _        => lask_ + "si"  --käisin, käis; muutsin, muutis
         }; 
            
      tuld_ = Predef.tk 2 tuldud ; --d/t choice for tuldi etc.
      tulgu = (init tulge) + "u" ;
      --luge_ = Predef.tk 2 tulge ; --joo(ge); tul(ge); luge(ge) ;
      lugenud = (hjk_type_IVb_maakas tulnud).s ;
      loetud = (hjk_type_IVb_maakas tuldud).s ;
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
      Impf Sg P1  => kaisi_ + "n" ;   --# notpresent
      Impf Sg P2  => kaisi_ + "d" ;  --# notpresent
      Impf Sg P3  => tuli ;  --# notpresent
      Impf Pl P1  => kaisi_ + "me" ;  --# notpresent
      Impf Pl P2  => kaisi_ + "te" ;  --# notpresent
      Impf Pl P3  => kaisi_ + "d" ;  --# notpresent
      Condit Sg P1 => tule_ + "ksin" ;  --# notpresent
      Condit Sg P2 => tule_ + "ksid" ;  --# notpresent
      Condit Sg P3 => tule_ + "ks";  --# notpresent
      Condit Pl P1 => tule_ + "ksime" ;  --# notpresent
      Condit Pl P2 => tule_ + "ksite" ;  --# notpresent
      Condit Pl P3 => tule_ + "ksid" ;  --# notpresent
      Imper Sg   => tule_ ; -- tule
      Imper Pl   => tulge ; -- tulge
      ImperP3 Sg => tulgu ; -- ta tulgu ?
      ImperP3 Pl => tulgu ; -- nad tulgu ?
      ImperP1Pl  => tulge + "m" ; -- me tulgem ?
      ImpNegPl   => tulge ; -- ärge tulge ?
      PassPresn True  => tullakse ;
      PassPresn False => tuld_ + "a" ; --da or ta
      PassImpf  True  => tuld_ + "i" ; --di or ti
      PassImpf  False => tuldud ;  
      --TODO Quotative
      PresPart => laulev ;
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
    sc = NPCase Nom ;

    lock_V = <>
    } ;

    
    vForms4 : (x1,_,_,x4 : Str) -> VForms4 =
      \kinkima,kinkida,kingib,kingitakse ->
      table {
        0 => kinkima ;
        1 => kinkida ;
        2 => kingib ;
        3 => kingitakse
      } ;
      
    -- (Experimental) Full paradigm from 4 base forms.
    -- Analoogiaseosed pöördsõna paradigmas
    -- http://www.eki.ee/books/ekk09/index.php?p=3&p1=5&id=227
    -- TODO: ma: kinkivat
    mk_forms4_to_verb : VForms4 -> Verb = \vh ->
    let
      vestlema = vh ! 0 ;
      vestelda = vh ! 1 ;
      kingib = vh ! 2 ;
      kingitakse = vh ! 3 ;
      vestle_ = Predef.tk 2 vestlema ;
      vestel_ = Predef.tk 2 vestelda ;
      kingi_ = init kingib ;
      kingit_ = Predef.tk 4 kingitakse ;
      laulev = case (last vestle_) of {
          ("a"|"e"|"i"|"o"|"õ"|"u"|"ü"|"ä"|"ö") => vestle_ + "v" ;
          _ => vestle_ + "ev" } ; --consonant stem in -ma, add e
      kinkinud = (hjk_type_IVb_maakas (vestel_ + "nud")).s ;
      kingitud = (hjk_type_IVb_maakas (kingit_ + "ud")).s ;
    in
    {s = table {
      Inf InfDa => vestelda ;
      Inf InfDes => vestel_ + "des" ;
      Presn Sg P1 => kingi_ + "n" ;
      Presn Sg P2 => kingi_ + "d" ;
      Presn Sg P3 => kingib ;
      Presn Pl P1 => kingi_ + "me" ;
      Presn Pl P2 => kingi_ + "te" ;
      Presn Pl P3 => kingi_ + "vad" ;
      Impf Sg P1  => vestle_ + "sin" ;   --# notpresent
      Impf Sg P2  => vestle_ + "sid" ;  --# notpresent
      Impf Sg P3  => vestle_ + "s" ;  --# notpresent
      Impf Pl P1  => vestle_ + "sime" ;  --# notpresent
      Impf Pl P2  => vestle_ + "site" ;  --# notpresent
      Impf Pl P3  => vestle_ + "sid" ;  --# notpresent
      Condit Sg P1 => kingi_ + "ksin" ;  --# notpresent
      Condit Sg P2 => kingi_ + "ksid" ;  --# notpresent
      Condit Sg P3 => kingi_ + "ks" ;  --# notpresent
      Condit Pl P1 => kingi_ + "ksime" ;  --# notpresent
      Condit Pl P2 => kingi_ + "ksite" ;  --# notpresent
      Condit Pl P3 => kingi_ + "ksid" ;  --# notpresent
      Imper Sg   => kingi_ ; -- kingi!
      Imper Pl   => vestel_ + "ge" ; -- vestelge
      ImperP3 Sg => vestel_ + "gu" ; -- ta vestelgu ?
      ImperP3 Pl => vestel_ + "gu" ; -- nad vestelgu ?
      ImperP1Pl  => vestel_ + "gem" ; -- me vestelgem ?
      ImpNegPl   => vestel_ + "ge" ; -- ärge vestelge ?
      PassPresn True  => kingitakse ;
      PassPresn False => kingit_ + "a" ;
      PassImpf  True  => kingit_ + "i" ; --di or ti
      PassImpf  False => kingit_ + "ud" ;  
      PresPart => laulev ;
      PastPartAct (AN n)  => kinkinud ! n ;
      PastPartAct AAdv    => kinkinud ! (NCase Sg Ablat) ;
      PastPartPass (AN n) => kingitud ! n ;
      PastPartPass AAdv   => kingitud ! (NCase Sg Ablat) ;
      Inf InfMa => vestlema ;
      Inf InfMas => vestlema + "s" ;
      Inf InfMast  => vestlema + "st" ;
      Inf InfMaks => vestlema + "ks" ;
      Inf InfMata => vestlema + "ta"
      } ;
    sc = NPCase Nom ;
    lock_V = <>
    } ;
    
-----------------------------------------
-- Auxiliaries
-----------------------------------------

-- The following function defines how grade alternation works if it is active.
-- In general, *whether there is* grade alternation must be given in the lexicon
-- (cf. "auto - auton" not "audon"; "vihje - vihjeen" not "vihkeen").

  weakGrade : Str -> Str = \kukko ->
    let
      ku  = Predef.tk 3 kukko ;
      kko = Predef.dp 3 kukko ;
      o   = last kukko
    in
      case kko of {
        "kk" + _ => ku + "k"  + o ;
        "pp" + _ => ku + "p"  + o ;
        "tt" + _ => ku + "t"  + o ;
        "nk" + _ => ku + "ng" + o ;
        "nt" + _ => ku + "nd" + o ;
        "nd" + _ => ku + "nn" + o ;
        "ad" + _ => ku + "aj" + o ; -- TODO: maybe any vowel, not just 'a'
        "mb" + _ => ku + "mm" + o ;
        "ug" + _ => ku + "o" + o ;  -- luge -> loe
        "ub" + _ => ku + "o" + o ;  -- tuba -> toa  
        "rt" + _ => ku + "rr" + o ;
        "lt" + _ => ku + "ll" + o ;
        "lk" + ("i" | "e") => ku + "lj" + o ;
        "rk" + ("i" | "e") => ku + "rj" + o ;
        "lk" + _ => ku + "l" + o ;
        "rk" + _ => ku + "r" + o ;
        ("hk" | "tk") + _ => kukko ;           -- *tahko-tahon, *pitkä-pitkän
        "s" + ("k" | "p" | "t") + _ => kukko ; -- *lasku-lasvun, *raspi-rasvin, *lastu-lasdun
        x + "k" + ("a" | "e" | "i" | "o" | "u") => ku + x + "g" + o ;
        x + "p" + ("a" | "e" | "i" | "o" | "u") => ku + x + "b" + o ;
        x + "t" + ("a" | "e" | "i" | "o" | "u") => ku + x + "d" + o ; -- oota -> ooda
        _ => kukko
        } ;

-- This is used to analyse nouns "rae", "hake", "rengas", "laidun", etc.

  strongGrade : Str -> Str = \hinne ->
    let
      hi = Predef.tk 3 hinne ;
      nne = Predef.dp 3 hinne ; 
    in 
    hi + case nne of {
--      "ng" + a => "nk" + a ;
      "nn" + e => "nd" + e ;
--      "mm" + e => "mp" + e ;
--      "rr" + e => "rt" + e ;
--      "ll" + a => "lt" + a ;
--      h@("h" | "l") + "je" + e => h + "ke" ; -- pohje/lahje impossible
--      ("tk" | "hk" | "sk" | "sp" | "st") + _ => nke ;       -- viuhke,kuiske 
      a + k@("k"|"p"|"t") + e@("e"|"a"|"ä"|"u"|"y"|"i"|"o"|"ö")  => a + k + k + e ;
--      a + "d" + e@("e"|"a"|"ä"|"u"|"i"|"o"|"ö")  => a + "t" + e ; 
--      s + a@("a" | "ä") + "e" => s + a + "ke" ;       -- säe, tae
--      s + "ui"                      => s + "uki" ;     -- ruis
--      s + "aa"                      => s + "aka" ;       -- taata
--      s + "i" + a@("a" | "e" | "i") => s + "ik" + a ;       -- liata, siitä, pietä
--      a + "v" + e@("e"|"a"|"ä"|"u"|"i") => a + "p" + e ;  -- taive/toive imposs
      ase => ase
      } ;


  strongGradeFin : Str -> Str = \hanke ->
    let
      ha = Predef.tk 3 hanke ;
      nke = Predef.dp 3 hanke ; 
    in 
    ha + case nke of {
      "ng" + a => "nk" + a ;
      "nn" + e => "nt" + e ;
      "mm" + e => "mp" + e ;
      "rr" + e => "rt" + e ;
      "ll" + a => "lt" + a ;
      h@("h" | "l") + "je" + e => h + "ke" ; -- pohje/lahje impossible
      ("tk" | "hk" | "sk" | "sp" | "st") + _ => nke ;       -- viuhke,kuiske 
      a + k@("k"|"p"|"t") + e@("e"|"a"|"ä"|"u"|"y"|"i"|"o"|"ö")  => a + k + k + e ;
      a + "d" + e@("e"|"a"|"ä"|"u"|"i"|"o"|"ö")  => a + "t" + e ; 
      s + a@("a" | "ä") + "e" => s + a + "ke" ;       -- säe, tae
      s + "ui"                      => s + "uki" ;     -- ruis
      s + "aa"                      => s + "aka" ;       -- taata
      s + "i" + a@("a" | "e" | "i") => s + "ik" + a ;       -- liata, siitä, pietä
      a + "v" + e@("e"|"a"|"ä"|"u"|"i") => a + "p" + e ;  -- taive/toive imposs
      ase => ase
      } ;

  -- TODO: not sure if we can do anything with these
  -- for Estonian
  vowHarmony : Str -> Str = \s -> case s of {
    _ + ("a" | "o" | "u") + _ => "a" ;
    _ => "i"
    } ;

  getHarmony : Str -> Str = \u -> case u of {
    "a"|"o"|"u" => "a" ;
    _   => "i"
    } ;

-----------------------
-- for Structural
-----------------------

caseTable : Number -> CommonNoun -> Case => Str = \n,cn -> 
  \\c => cn.s ! NCase n c ;

  mkDet : Number -> CommonNoun -> {
      s,sp : Case => Str ;       -- minun kolme
      n : Number ;             -- Pl   (agreement feature for verb)
      isNum : Bool ;           -- True (a numeral is present)
      isDef : Bool             -- True (verb agrees in Pl, Nom is not Part)
      } = \n, noun -> heavyDet {
    s = \\c => noun.s ! NCase n c ;
    n = n ;
    isNum = False ;
    isDef = True  --- does this hold for all new dets?
    } ;

-- Here we define personal and relative pronouns.

  -- input forms: Nom, Gen, Part
  -- Note that the Fin version required 5 input forms, the
  -- Est pronouns thus seem to be much simpler.
  -- TODO: remove NPAcc?
  mkPronoun : (_,_,_ : Str) -> Number -> Person ->
    {s : NPForm => Str ; a : Agr} = 
    \mina, minu, mind, n, p ->
    let {
      minu_short = ie_to_i minu
    } in 
    {s = table {
      NPCase Nom    => mina ;
      NPCase Gen    => minu ;
      NPCase Part   => mind ;
      NPCase Transl => minu + "ks" ;
      NPCase Ess    => minu + "na" ;
      NPCase Iness  => minu_short + "s" ;
      NPCase Elat   => minu_short + "st" ;
      NPCase Illat  => minu_short + "sse" ;
      NPCase Adess  => minu_short + "l" ;
      NPCase Ablat  => minu_short + "lt" ;
      NPCase Allat  => minu_short + "le" ;
      NPCase Abess  => minu + "ta" ;
      NPCase Comit  => minu + "ga" ;
      NPCase Termin => minu + "ni" ;
      NPAcc         => mind
      } ;
     a = Ag n p
    } ; 

  -- meiesse/teiesse -> meisse/teisse
  ie_to_i : Str -> Str ;
  ie_to_i x =
	case x of {
		x1 + "ie" + x2 => x1 + "i" + x2 ;
		_ => x
	} ;

  -- TODO: this does not seem to be called from anyway
  mkDemPronoun : (_,_,_,_,_ : Str) ->  Number -> 
    {s : NPForm => Str ; a : Agr} = 
    \tuo, tuon, tuota, tuona, tuohon, n ->
    let pro = mkPronoun tuo tuon tuota n P3
    in {
      s = table {
        NPAcc => tuo ;
        c => pro.s ! c
        } ;
      a = pro.a
      } ;

-- The relative pronoun, "joka", is inflected in case and number, 
-- like common nouns, but it does not take possessive suffixes.
-- The inflextion shows a surprising similarity with "suo".

oper
  -- TODO: fix: Nom => kelled
  -- TODO: mis
  relPron : Number => Case => Str =
    let kes = hjk_nForms6 "kes" "kelle" "keda" "kellesse" "kelle" "keda" in
    \\n,c => kes.s ! NCase n c ;

  ProperName = {s : Case => Str} ;

  -- TODO: generate using mkPronoun
  pronSe : ProperName  = {
    s = table {
      Nom    => "see" ;
      Gen    => "selle" ;
      Part   => "seda" ;
      Transl => "selleks" ;
      Ess    => "sellena" ;
      Iness  => "selles" ;
      Elat   => "sellest" ;
      Illat  => "sellesse" ;
      Adess  => "sellel" ;
      Ablat  => "sellelt" ;
      Allat  => "sellele" ;
      Abess  => "selleta" ;
      Comit  => "sellega" ;
      Termin => "selleni"
      } ;
    } ;

  -- TODO: generate using mkPronoun
  pronNe : ProperName  = {
    s = table {
      Nom    => "need" ;
      Gen    => "nende" ;
      Part   => "neid" ;
      Transl => "nendeks" ;
      Ess    => "nendena" ;
      Iness  => "nendes" ;
      Elat   => "nendest" ;
      Illat  => "nendesse" ;
      Adess  => "nendel" ;
      Ablat  => "nendelt" ;
      Allat  => "nendele" ;
      Abess  => "nendeta" ;
      Comit  => "nendega" ;
      Termin => "nendeni" 
      } ;
    } ;

}
