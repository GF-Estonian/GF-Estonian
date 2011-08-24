--# -path=.:../common:prelude

--1 A Simple Estonian Resource Morphology
--
-- Aarne Ranta (, Inari Listenmaa, Kaarel Kaljurand)
--
-- This resource morphology contains definitions needed in the resource
-- syntax. To build a lexicon, it is better to use $ParadigmsEst$, which
-- gives a higher-level access to this module.

resource MorphoEst = ResEst ** open Prelude in {

  flags optimize=all ; coding=utf8;

  oper
  --Estonian paradigms

  --Inflection paradigms from tüüpsõnad 

  --tüüpsõnad 1
  dKoi : Str -> NForms = \koi ->
    nForms7
      koi koi (koi + "d") (koi + "sse")            -- sg nom, gen, part, ill
      (koi + "de") (koi + "sid") (koi + "desse") ; -- pl      gen, part, ill

  --tüüpsõnad 2
  -- luu, luu, luud, .luusse, (.)luude, luid ja  .luusid, (.)luudesse ja .luisse
  dLuu : Str -> NForms = \luu ->
    let 
      lui = (Predef.tk 1 luu) + "i" ;
    in nForms7
      luu luu (luu + "d") (luu + "sse")        -- sg nom, gen, part, ill
      (luu + "de") (lui + "d") (luu + "desse") ; -- pl      gen, part, ill


  --tüüpsõnad 3: short sg illative; non-predictable vowel in pl part and ill
  dPesa : (_,_ : Str) -> NForms = \pesa,pesi ->
    let 
      pes   = Predef.tk 1 pesa ;
      s     = last pes ;
      pessa = pes + s + last pesa ;
    in nForms7
      pesa pesa pesa pessa                  -- sg nom, gen, part, ill
      (pesa + "de") pesi (pesa + "desse") ; -- pl      gen, part, ill

--pesa, pesa, pesa, .pessa ja pesasse, pesade, pesasid ja pesi, pesadesse ja pesisse
--saba, saba, saba, .sappa ja sabasse, sabade, sabasid ja sabu, sabadesse ja sabusse
--arutelu, arutelu, arutelu, aru.tellu ja arutelusse, arutelude, arutelusid, aruteludesse


  --tüüpsõnad 4: i-e change, otherwise regular
  dSuvi : Str -> NForms = \suvi ->
    let 
      suve = Predef.tk 1 suvi + "e" 
    in nForms7
      suvi suve suve (suve + "sse")                   -- sg nom, gen, part, ill
      (suve + "de") (suve + "sid") (suve + "desse") ; -- pl      gen, part, ill

  --5 later

  --6: loan words, stem vowel always i, sg nom ends in consonant
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
  --   stem vowel i, difference in pl.part: i~eid
  dNumber : (_,_ : Str) -> NForms = \number,numbri ->
    let
      numbr = Predef.tk 1 numbri --the consonant stem
    in nForms7
      number numbri (numbri + "t") (numbri + "sse")
      (numbri + "te") (numbr + "eid") (numbri + "tesse") ;

  --10: ase, aseme

  --11: -se in stem, pl.part -eid. Like 13, but vowel insertion in part,gen etc.
  --dRaudne : Str -> NForms

  --12: -se in stem, pl.part -si
  --     sg.nom can be -ne or -s (oluline ; peegeldus)
  dNaine : Str -> NForms = \naine ->
    let 
      nais : Str = case naine of {
        _ + "ne" => Predef.tk 2 naine + "s" ;
        _ + "s"  => naine    -- if nominative ends in s already
      } 
    in nForms7
      naine (nais + "e") (nais + "t") (nais + "esse")
      (nais + "te") (nais + "i") (nais + "tesse") ; -- pl gen, part, ill
 
  --13: -se in stem, pl.part -eid
  dSoolane : Str -> NForms = \soolane ->
    let 
      soolas : Str = case soolane of {
        _ + "ne" => Predef.tk 2 soolane + "s" ;
        _ + "s"  => soolane
      } ;
      soolase : Str = soolas + "e"
    in nForms7
      soolane soolase (soolas + "t") (soolas + "esse")
      (soolas + "te") (soolase + "id") (soolas + "tesse") ; -- pl gen, part, ill

  

  dOun : Str -> NForms = \oun ->
    let 
      ouna = oun + "a" ;
    in nForms7
      oun ouna ouna (ouna + "sse")
      (oun + "te") (oun + "u") (oun + "tesse") ; -- pl gen, part, ill


----- Finnish paradigms

  dLujuus : Str -> NForms = \lujuus -> 
    let
      lujuu = init lujuus ;
      lujuuksi = lujuu + "ksi" ;
      a = vowHarmony (last lujuu) ;
    in nForms10
      lujuus (lujuu + "den") (lujuu + "tt" + a) 
      (lujuu + "ten" + a) (lujuu + "teen")
      (lujuuksi + "en") (lujuuksi + a) 
      (lujuuksi + "n" + a) (lujuuksi + "ss" + a) (lujuuksi + "in") ; 


  dPaluu : Str -> NForms = \paluu ->
    let
      a = vowHarmony paluu ;
      palui = init paluu + "i" ;
      u = last paluu ;
    in nForms10
      paluu (paluu + "n") (paluu + "t" + a) (paluu + "n" + a)  (paluu + "seen")
      (palui + "den") (palui + "t" + a) 
      (palui + "n" + a) (palui + "ss" + a) (palui + "siin") ;

  dPuu : Str -> NForms = \puu ->
    let
      a = vowHarmony puu ;
      pui = init puu + "i" ;
      u = last puu ;
    in nForms10
      puu (puu + "n") (puu + "t" + a) (puu + "n" + a)  (puu + "h" + u + "n")
      (pui + "den") (pui + "t" + a) 
      (pui + "n" + a) (pui + "ss" + a) (pui + "hin") ;

  dSuo : Str -> NForms = \suo ->
    let
      o = last suo ;
      a = vowHarmony o ;
      soi = Predef.tk 2 suo + o + "i" ;
    in nForms10
      suo (suo + "n") (suo + "t" + a) (suo + "n" + a)  (suo + "h" + o + "n")
      (soi + "den") (soi + "t" + a) 
      (soi + "n" + a) (soi + "ss" + a) (soi + "hin") ;

  dKorkea : Str -> NForms = \korkea ->
    let
      a = last korkea ;
      korke = init korkea ;
    in nForms10
      korkea (korkea + "n") (korkea + a) 
      (korkea + "n" + a)  (korkea + a + "n")
      (korke + "iden") (korke + "it" + a) 
      (korke + "in" + a) (korke + "iss" + a) 
      (korke + "isiin") ; --- NSSK: korkeihin

  dKaunis : Str -> NForms = \kaunis ->
    let
      a = vowHarmony kaunis ;
      kaunii = init kaunis + "i" ;
    in nForms10
      kaunis (kaunii + "n") (kaunis + "t" + a) 
      (kaunii + "n" + a)  (kaunii + "seen")
      (kaunii + "den") (kaunii + "t" + a) 
      (kaunii + "n" + a) (kaunii + "ss" + a) 
      (kaunii + "siin") ;

  dLiitin : (_,_ : Str) -> NForms = \liitin,liittimen ->
    let
      a = vowHarmony liitin ;
      liittim = Predef.tk 2 liittimen ;
    in nForms10
      liitin (liittim + "en") (liitin + "t" + a) 
      (liittim + "en" + a)  (liittim + "een")
      (liittim + "ien") (liittim + "i" + a) 
      (liittim + "in" + a) (liittim + "iss" + a) 
      (liittim + "iin") ;

  dOnneton : Str -> NForms = \onneton ->
    let
      a = vowHarmony onneton ;
      onnettom = Predef.tk 2 onneton + "t" + last (init onneton) + "m" ;
    in nForms10
      onneton (onnettom + a + "n") (onneton + "t" + a) 
      (onnettom + a + "n" + a)  (onnettom + a + a + "n")
      (onnettom + "ien") (onnettom + "i" + a) 
      (onnettom + "in" + a) (onnettom + "iss" + a) 
      (onnettom + "iin") ;

  -- 2-syllable a/ä, o/ö, u/y
  dUkko : (_,_ : Str) -> NForms = \ukko,ukon ->
      let
        o   = last ukko ;
        a   = vowHarmony o ;
        ukk = init ukko ;
        uko = init ukon ;
        uk  = init uko ;
        ukkoja = case <ukko : Str> of {
          _ + "ä" =>                        -- kylä,kyliä,kylien,kylissä,kyliin 
             <ukk + "iä", ukk + "ien", ukk, uk, ukk + "iin"> ;
          _ + ("au" | "eu") + _ + "a" =>    -- kauhojen,seurojen
             <ukk + "oja",ukk + "ojen",ukk + "o", uk + "o", ukk + "oihin"> ;
          _ + ("o" | "u") + _ + "a" =>      -- pula,pulia,pulien,pulissa,puliin
             <ukk + "ia", ukk + "ien", ukk, uk, ukk + "iin"> ;
          _ + "a" =>                        -- kala,kaloja,kalojen,-oissa,-oihin
             <ukk + "oja",ukk + "ojen",ukk + "o", uk + "o", ukk + "oihin"> ;
          _   =>                            -- suku,sukuja,sukujen,-uissa,-uihin
             <ukko + "j" + a,ukko + "jen",ukko, uko, ukko + "ihin">
        } ;
        ukkoina = ukkoja.p3 + "in" + a ; 
        ukoissa = ukkoja.p4 + "iss" + a ;
      in nForms10
        ukko ukon (ukko + a) (ukko + "n" + a) (ukko + o + "n")
        ukkoja.p2 ukkoja.p1
        ukkoina ukoissa ukkoja.p5 ; 

  -- 3-syllable a/ä/o/ö
  dSilakka : (_,_,_ : Str) -> NForms = \silakka,silakan,silakoita ->
    let
      o = last silakka ;
      a = getHarmony o ;
      silakk = init silakka ;
      silaka = init silakan ;
      silak  = init silaka ;
      silakkaa = silakka + case o of {
        "o" | "ö" => "t" + a ;  -- radiota
        _ => a                  -- sammakkoa
        } ;
      silakoiden = case <silakoita : Str> of {
        _ + "i" + ("a" | "ä") =>                    -- asemia
          <silakka+a, silakk + "ien", silakk, silak, silakk + "iin"> ;
        _ + O@("o" | "ö" | "u" | "y" | "e") + ("ja" | "jä") =>        -- pasuunoja
          <silakka+a,silakk+O+"jen",silakk+O, silak+O, silakk +O+ "ihin"> ;
        _ + O@("o" | "ö" | "u" | "y" | "e") + ("ita" | "itä") =>      -- silakoita
          <silakkaa, silak+O+"iden",silakk+O, silak+O, silakk +O+ "ihin"> ;
        _   => Predef.error silakoita                    
        } ;
      silakkoina = silakoiden.p3 + "in" + a ; 
      silakoissa = silakoiden.p4 + "iss" + a ;
    in nForms10
      silakka silakan silakoiden.p1 (silakka + "n" + a) (silakka + o + "n")
      silakoiden.p2 silakoita
      silakkoina silakoissa silakoiden.p5 ; 

   dArpi : (_,_ : Str) -> NForms = \arpi,arven ->
      let
        a = vowHarmony arpi ;
        arp = init arpi ;
        arv = Predef.tk 2 arven ;
        ar  = init arp ;
        arpe = case last arp of {
         "s" => case last arv of {
            "d" | "l" | "n" | "r" =>   -- suden,sutta ; jälsi ; kansi ; hirsi
               <ar + "tt" + a, arpi + "en",arpi,ar + "t"> ;
            _ =>                                     -- kuusta,kuusien
               <arp + "t" + a,arp + "ien",arpi, arp>
            } ;
         "r" | "n" =>                                -- suurta,suurten
               <arp + "t" + a,arp + "ten",arpi, arp>; 
         "l" | "h" =>                           -- tuulta,tuulien
               <arp + "t" + a,arp + "ien",arpi, arp>; 
          _   =>                                -- arpea,arpien,arvissa
               <arp + "e" + a,arp + "ien",arv+"i",arp>   
          } ;                                   ---- pieni,pientä; uni,unta
        in nForms10
            arpi arven arpe.p1 (arpe.p4 + "en" + a) (arpe.p4 + "een")
            arpe.p2 (arpi + a)
            (arp + "in" + a) (arpe.p3 + "ss" + a) (arp + "iin") ; 

  dRae : (_,_ : Str) -> NForms = \rae,rakeen ->
      let
        a = vowHarmony rae ;
        rakee  = init rakeen ;
        rakei  = init rakee + "i" ;
        raetta = case <rae : Str> of {
          _ + "e" => 
            <rae + "tt" + a, rakee + "seen"> ;  -- raetta,rakeeseen
          _ + "u" => 
            <rae + "tt" + a, rakee + "seen"> ;  -- kiiru, kiiruuseen
          _ + "i" => 
            <rae + "tt" + a, rakee + "seen"> ;  -- ori, oriin
          _ + "s" => 
            <rae + "t" + a,  rakee + "seen"> ;  -- rengasta,renkaaseen
          _ + "t" => 
            <rae + "t" + a,  rakee + "en"> ;    -- olutta,olueen
          _ + "r" => 
            <rae + "t" + a,  rakee + "en"> ;    -- sisarta,sisareen
          _ => Predef.error (["expected ending e/t/s/r, found"] ++ rae)
          } ;
        in nForms10
          rae rakeen raetta.p1 (rakee + "n"+ a) raetta.p2
          (rakei + "den") (rakei + "t" + a)
          (rakei + "n" + a) (rakei + "ss" + a) (rakei + "siin") ; ---- sisariin

  dPaatti : (_,_ : Str) -> NForms = \paatti,paatin ->
    let
      a = vowHarmony paatti ;
      paatte = init paatti + "e" ;
      paati = init paatin ;
      paate = init paati + "e" ;
    in nForms10
      paatti paatin (paatti + a) (paatti + "n" + a) (paatti + "in")
      (paatti + "en") (paatte + "j" + a) 
      (paatte + "in" + a) (paate + "iss" + a) (paatte + "ihin") ; 

  dTohtori : (_ : Str) -> NForms = \tohtori ->
    let
      a = vowHarmony tohtori ;
      tohtor = init tohtori ;
    in nForms10
      tohtori (tohtori+"n") (tohtori + a) (tohtori + "n" + a) (tohtori + "in")
      (tohtor + "eiden") (tohtor + "eit" + a) 
      (tohtor + "ein" + a) (tohtor + "eiss" + a) (tohtor + "eihin") ; 

  dPiennar : (_,_ : Str) -> NForms = \piennar,pientaren ->
    let 
      a = vowHarmony piennar ;
      pientar = Predef.tk 2 pientaren ;
    in nForms10
      piennar pientaren (piennar +"t" + a) 
      (pientar + "en" + a) (pientar + "een")
      (piennar + "ten") (pientar + "i" + a) (pientar + "in" + a)
      (pientar + "iss" + a) (pientar + "iin") ;


  dNukke : (_,_ : Str) -> NForms = \nukke,nuken ->
    let
      a = vowHarmony nukke ;
      nukk = init nukke ;
      nuke = init nuken ;
    in
    nForms10
      nukke nuken (nukke + a) (nukk +"en" + a) (nukk + "een")
      (nukk + "ien") (nukk + "ej" + a) (nukk + "ein" + a)
      (nuke + "iss" + a) (nukk + "eihin") ;

  dJalas : Str -> NForms = \jalas -> 
    let
      a = vowHarmony jalas ;
      jalaks = init jalas + "ks" ;
      jalaksi = jalaks + "i" ;
    in nForms10
      jalas (jalaks + "en") (jalas + "t" + a) 
      (jalaks + "en" + a) (jalaks + "een")
      (jalas + "ten") (jalaksi + a) 
      (jalaksi + "n" + a) (jalaksi + "ss" + a) (jalaksi + "in") ; 

  dSDP : Str -> NForms = \SDP ->
    let
      c = case last SDP of {
 
--      c = case Predef.toUpper (last SDP) of {
        "A" => 
           <"n","ta","na","han","iden","ita","ina","issa","ihin"> ;
        "B" | "C" | "D" | "E" | "G" | "P" | "T" | "V" | "W" => 
           <"n","tä","nä","hen","iden","itä","inä","issä","ihin"> ;
        "F" | "L" | "M" | "N" | "R" | "S" | "X" => 
           <"n","ää","nä","ään","ien","iä","inä","issä","iin"> ;
        "H" | "K" | "O" | "Å" => 
           <"n","ta","na","hon","iden","ita","ina","issa","ihin"> ;
        "I" | "J" => 
           <"n","tä","nä","hin","iden","itä","inä","issä","ihin"> ;
        "Q" | "U" => 
           <"n","ta","na","hun","iden","ita","ina","issa","ihin"> ;
        "Z" => 
           <"n","aa","na","aan","ojen","oja","oina","oissa","oihin"> ;
        "Ä" => 
           <"n","tä","nä","hän","iden","itä","inä","issä","ihin"> ;
        "Ö" => 
           <"n","tä","nä","hön","iden","itä","inä","issä","ihin"> ;
        "Y" => 
           <"n","tä","nä","hyn","iden","itä","inä","issä","ihin"> ;
        _ => Predef.error (["illegal abbreviation"] ++ SDP)
        } ;
    in nForms10
      SDP (SDP + ":" + c.p1) (SDP + ":" + c.p2) (SDP + ":" + c.p3) 
      (SDP + ":" + c.p4) (SDP + ":" + c.p5) (SDP + ":" + c.p6) 
      (SDP + ":" + c.p7) (SDP + ":" + c.p8) (SDP + ":" + c.p9) ;

-- for adjective comparison

  dSuurempi : Str -> NForms = \suurempi ->
    let
      a = vowHarmony suurempi ;
      suuremp = init suurempi ;
      suuremm = Predef.tk 2 suurempi + "m" ;
    in nForms10
      suurempi (suuremm + a + "n") (suuremp + a + a) 
      (suuremp + a + "n" + a) (suuremp + a + a + "n")
      (suuremp + "ien") (suurempi + a) 
      (suurempi + "n" + a) (suuremm + "iss" + a) (suurempi + "in") ; 

  dSuurin : Str -> NForms = \suurin ->
    let
      a = vowHarmony suurin ;
      suurimm = init suurin + "mm" ;
      suurimp = init suurimm + "p" ;
    in nForms10
      suurin (suurimm + a + "n") (suurin + "t" + a) 
      (suurimp + a + "n" + a) (suurimp + a + a + "n")
      (suurimp + "ien") (suurimp + "i" + a) 
      (suurimp + "in" + a) (suurimm + "iss" + a) (suurimp + "iin") ; 

-- for verb participle forms

  dOttanut : Str -> NForms = \ottanut ->
    let
      a = vowHarmony ottanut ;
      ottane = Predef.tk 2 ottanut + "e" ;
      ottanee = ottane + "e" ;
    in nForms10
      ottanut (ottanee + "n") (ottanut + "t" + a) 
      (ottanee + "n" + a) (ottanee + "seen")
      (ottane + "iden") (ottane + "it" + a) 
      (ottane + "in" + a) (ottane + "iss" + a) (ottane + "isiin") ; 


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


{------------------------ FINNISH 

    Noun = {s : NForm => Str; lock_N : {}} ;

    nForms2N : NForms -> Noun = \f -> 
      let
        jogi = f ! 0 ;
        joe = f ! 1 ;
        joge = f ! 2 ;
        joena = f ! 3 ;
        joesse = f ! 4 ;
        jogede = f ! 5 ;
        jogesid = f ! 6 ;
        jogedena = f ! 7 ;
        jogedes = f ! 8 ;
        jogedesse = f ! 9 ;
        --a     = last ukkoja ; -- no vowel harmony,no need
        --uko   = init ukon ; -- genetive is already the stem
        jog  = Predef.tk 1 joge ; --???
       --  = Predef.tk 2 ukkoina ;
       -- ukoi  = Predef.tk 3 ukoissa ;
      in 
    {s = table {
      NCase Sg Nom    => jogi ;
      NCase Sg Gen    => joe ;
      NCase Sg Part   => joge ;
      NCase Sg Transl => joe + "ks" ;
      NCase Sg Ess    => joena ;
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
      NCase Pl Ess    => jogedena ;
      NCase Pl Iness  => jogede + "s" ;
      NCase Pl Elat   => jogede + "st" ;
      NCase Pl Illat  => jogedesse ;
      NCase Pl Adess  => jogede + "l" ;
      NCase Pl Ablat  => jogede + "lt" ;
      NCase Pl Allat  => jogede + "le" ;
      NCase Pl Abess  => jogede + "ta" ;
      NCase Pl Comit  => jogede + "ga" ;
      NCase Pl Termin => jogede + "ni"    
   --Not in Estonian

      } ;
    lock_N = <>
    } ;

  n2nforms : Noun -> NForms = \ukko -> table {
    0 => ukko.s ! NCase Sg Nom ;
    1 => ukko.s ! NCase Sg Gen ;
    2 => ukko.s ! NCase Sg Part ;
    3 => ukko.s ! NCase Sg Ess ;
    4 => ukko.s ! NCase Sg Illat ;
    5 => ukko.s ! NCase Pl Gen ;
    6 => ukko.s ! NCase Pl Part ;
    7 => ukko.s ! NCase Pl Ess ;
    8 => ukko.s ! NCase Pl Iness ;
    9 => ukko.s ! NCase Pl Illat
  } ;
-----------------------------------------------}
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
        compar = dSuurempi (suure ++ "mpi") ;
        superl = dSuurin   (suur ++ "in") ;
        adv_posit = suure + "sti" ;
        adv_compar = suure + "mmin" ;
        adv_superl = suur + "immin" ;
      } ;


  oper

  cHukkua : (_,_ : Str) -> VForms = \hukkua,hukun -> 
    let
      a     = last hukkua ;
      hukku = init hukkua ;
      huku  = init hukun ;
      u     = last huku ;
      i = case u of {
        "e" | "i" => [] ;
        _ => u
        } ;
      y = uyHarmony a ;
      hukkui = init hukku + i + "i" ; 
      hukui  = init huku + i + "i" ; 
    in vForms12
      hukkua
      hukun
      (hukku + u)
      (hukku + "v" + a + "t")
      (hukku + "k" + a + a)
      (huku + "t" + a + a + "n")
      (hukui + "n")
      hukkui
      (hukkui + "si")
      (hukku + "n" + y + "t")
      (huku + "tt" + y)
      (hukku + "nee") ;

  cOttaa : (_,_,_,_ : Str) -> VForms = \ottaa,otan,otin,otti -> 
    let
      a    = last ottaa ;
      aa   = a + a ;
      u    = uyHarmony a ;
      ota  = init otan ;
      otta = init ottaa ;
      ote  = init ota + "e" ;
    in vForms12
      ottaa
      otan
      ottaa
      (otta + "v" + a + "t") 
      (otta + "k" + aa) 
      (ote  + "t" + aa + "n")
      otin
      otti
      (otta + "isi")
      (otta + "n" + u + "t")
      (ote + "tt" + u)
      (otta + "nee") ;

  cJuosta : (_,_ : Str) -> VForms = \juosta,juoksen -> 
    let
      a      = last juosta ;
      juos   = Predef.tk 2 juosta ;
      juoss  = juos + last juos ;
      juokse = init juoksen ;
      juoks  = init juokse ;
      u      = uyHarmony a ;
      juoksi = juoks + "i" ;
    in vForms12
      juosta
      (juoksen)
      (juokse + "e")
      (juokse + "v" + a + "t")
      (juos + "k" + a + a)
      (juosta + a + "n")
      (juoks + "in")
      (juoks + "i")
      (juoks + "isi")
      (juoss + u + "t")
      (juos + "t" + u)
      (juoss + "ee") ;

  cJuoda : (_ : Str) -> VForms = \juoda -> 
    let
      a      = last juoda ;
      juo    = Predef.tk 2 juoda ;
      joi    = case last juo of {
        "i" => juo ;                     -- naida
        o   => Predef.tk 2 juo + o + "i"
        } ;
      u      = uyHarmony a ;
    in vForms12
      juoda
      (juo + "n")
      (juo)
      (juo + "v" + a + "t")
      (juo + "k" + a + a)
      (juoda + a + "n")
      (joi + "n")
      (joi)
      (joi + "si")
      (juo + "n" + u + "t")
      (juo + "t" + u)
      (juo + "nee") ;

  cPudota : (_,_ : Str) -> VForms = \pudota,putosi -> 
    let
      a      = last pudota ;
      pudot  = init pudota ;
      pudo   = init pudot ;
      ai = case last pudo of {
        "a" | "ä" => <[], "i"> ;
        _         => <a, a + "i">
        } ;
      puto   = Predef.tk 2 putosi ;
      u      = uyHarmony a ;
    in vForms12
      pudota
      (puto  + a + "n")
      (puto  + ai.p1 + a)
      (puto  + a + "v" + a + "t")
      (pudot + "k" + a + a)
      (pudot + a + a + "n")
      (puto  + "sin")
      (puto  + "si")
      (puto  + ai.p2 + "si")
      (pudo  + "nn" + u + "t")
      (pudot + "t" + u)
      (pudo  + "nnee") ;

  cHarkita : (_ : Str) -> VForms = \harkita -> 
    let
      a      = last harkita ;
      harkit = init harkita ;
      harki  = init harkit ;
      u      = uyHarmony a ;
    in vForms12
      harkita
      (harkit + "sen")
      (harkit + "se")
      (harkit + "sev" + a + "t")
      (harkit + "k" + a + a)
      (harkit + a + a + "n")
      (harkit + "sin")
      (harkit + "si")
      (harkit + "sisi")
      (harki  + "nn" + u + "t")
      (harkit + "t" + u)
      (harki  + "nnee") ;

  cValjeta : (_,_ : Str) -> VForms = \valjeta,valkeni -> 
    let
      a      = last valjeta ;
      valjet = init valjeta ;
      valken = init valkeni ;
      valje  = init valjet ;
      u      = uyHarmony a ;
    in vForms12
      valjeta
      (valken + "en")
      (valken + "ee")
      (valken + "ev" + a + "t")
      (valjet + "k" + a + a)
      (valjet + a + a + "n")
      (valken + "in")
      (valken + "i")
      (valken + "isi")
      (valje  + "nn" + u + "t")
      (valjet + "t" + u)
      (valje  + "nnee") ;

  cKuunnella : (_,_ : Str) -> VForms = \kuunnella,kuuntelin -> 
    let
      a       = last kuunnella ;
      kuunnel = Predef.tk 2 kuunnella ;
      kuuntel = Predef.tk 2 kuuntelin ;
      u       = uyHarmony a ;
      l       = last kuunnel
    in vForms12
      kuunnella
      (kuuntel + "en")
      (kuuntel + "ee")
      (kuuntel + "ev" + a + "t")
      (kuunnel + "k" + a + a)
      (kuunnella + a + "n")
      (kuuntel + "in")
      (kuuntel + "i")
      (kuuntel + "isi")
      (kuunnel + l + u + "t")
      (kuunnel + "t" + u)
      (kuunnel + l + "ee") ;

-- auxiliaries

    uyHarmony : Str -> Str = \a -> case a of {
      "a" => "u" ;
      _ => "y"
      } ;

    VForms : Type = Predef.Ints 11 => Str ;

    vForms12 : (x1,_,_,_,_,_,_,_,_,_,_,x12 : Str) -> VForms = 
      \olla,olen,on,ovat,olkaa,ollaan,olin,oli,olisi,ollut,oltu,lienee ->
      table {
        0 => olla ;
        1 => olen ;
        2 => on ;
        3 => ovat ;
        4 => olkaa ;
        5 => ollaan ;
        6 => olin ;
        7 => oli ;
        8 => olisi ;
        9 => ollut ;
       10 => oltu ;
       11 => lienee
      } ;

    vforms2V : VForms -> Verb ** {qp : Bool} = \vh -> 
    let
      tulla = vh ! 0 ; 
      tulen = vh ! 1 ; 
      tulee = vh ! 2 ; 
      tulevat = vh ! 3 ;
      tulkaa = vh ! 4 ; 
      tullaan = vh ! 5 ; 
      tulin = vh ! 6 ; 
      tuli = vh ! 7 ;
      tulisi = vh ! 8 ;
      tullut = vh ! 9 ;
      tultu = vh ! 10 ;
      tullun = vh ! 11 ;
      tule_ = init tulen ;
      tuli_ = init tulin ;
      a = last tulkaa ;
      tulko = Predef.tk 2 tulkaa + (ifTok Str a "a" "o" "ö") ;
      tulkoo = tulko + last tulko ;
      tullee = Predef.tk 2 tullut + "ee" ;
      tulleen = (nForms2N (dOttanut tullut)).s ;
      tullu : Str = weakGrade tultu ;
      tullun  = (nForms2N (dUkko tultu (tullu + "n"))).s ; 
      tulema = Predef.tk 3 tulevat + "m" + a ;
      vat = "v" + a + "t"
    in
    {s = table {
      Inf Inf1 => tulla ;
      Presn Sg P1 => tule_ + "n" ;
      Presn Sg P2 => tule_ + "t" ;
      Presn Sg P3 => tulee ;
      Presn Pl P1 => tule_ + "mme" ;
      Presn Pl P2 => tule_ + "tte" ;
      Presn Pl P3 => tulevat ;
      Impf Sg P1  => tuli_ + "n" ;   --# notpresent
      Impf Sg P2  => tuli_ + "t" ;  --# notpresent
      Impf Sg P3  => tuli ;  --# notpresent
      Impf Pl P1  => tuli_ + "mme" ;  --# notpresent
      Impf Pl P2  => tuli_ + "tte" ;  --# notpresent
      Impf Pl P3  => tuli + vat ;  --# notpresent
      Condit Sg P1 => tulisi + "n" ;  --# notpresent
      Condit Sg P2 => tulisi + "t" ;  --# notpresent
      Condit Sg P3 => tulisi ;  --# notpresent
      Condit Pl P1 => tulisi + "mme" ;  --# notpresent
      Condit Pl P2 => tulisi + "tte" ;  --# notpresent
      Condit Pl P3 => tulisi + vat ;  --# notpresent
      Imper Sg   => tule_ ;
      Imper Pl   => tulkaa ;
      ImperP3 Sg => tulkoo + "n" ;
      ImperP3 Pl => tulkoo + "t" ;
      ImperP1Pl  => tulkaa + "mme" ;
      ImpNegPl   => tulko ;
      Pass True  => tullaan ;
      Pass False => Predef.tk 2 tullaan ;
      PastPartAct (AN n)  => tulleen ! n ;
      PastPartAct AAdv    => tullee + "sti" ;
      PastPartPass (AN n) => tullun ! n ;
      PastPartPass AAdv   => tullu + "sti" ;
      Inf Inf3Iness => tulema + "ss" + a ;
      Inf Inf3Elat  => tulema + "st" + a ;
      Inf Inf3Illat => tulema +  a   + "n" ;
      Inf Inf3Adess => tulema + "ll" + a ;
      Inf Inf3Abess => tulema + "tt" + a 
      } ;
    sc = NPCase Nom ;
    qp = pbool2bool (Predef.eqStr (last tulko) "o") ;
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
        "kk" + _ => ku + "k"  + o  ;
        "pp" + _ => ku + "p"  + o  ;
        "tt" + _ => ku + "t"  + o  ;
        "nk" + _ => ku + "ng" + o  ;
        "nt" + _ => ku + "nn" + o  ;
        "mp" + _ => ku + "mm" + o  ;
        "rt" + _ => ku + "rr" + o  ;
        "lt" + _ => ku + "ll" + o  ;
        "lk" + ("i" | "e") => ku + "lj" + o ;
        "rk" + ("i" | "e") => ku + "rj" + o ;
        "lk" + _ => ku + "l" + o  ;
        "rk" + _ => ku + "r" + o  ;
        ("hk" | "tk") + _ => kukko ;           -- *tahko-tahon, *pitkä-pitkän
        "s" + ("k" | "p" | "t") + _ => kukko ; -- *lasku-lasvun, *raspi-rasvin, *lastu-lasdun
        x + "ku" => ku + x + "vu" ;
        x + "k" + ("a" | "e" | "i" | "o" | "u" | "y" | "ä" | "ö") => ku + x      + o ; 
        x + "p" + ("a" | "e" | "i" | "o" | "u" | "y" | "ä" | "ö") => ku + x + "v" + o ; 
        x + "t" + ("a" | "e" | "i" | "o" | "u" | "y" | "ä" | "ö") => ku + x + "d" + o ; 
        _ => kukko
        } ;

-- This is used to analyse nouns "rae", "hake", "rengas", "laidun", etc.

  strongGrade : Str -> Str = \hanke ->
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

  vowHarmony : Str -> Str = \s -> case s of {
    _ + ("a" | "o" | "u") + _ => "a" ;
    _ => "ä"
    } ;

  getHarmony : Str -> Str = \u -> case u of {
    "a"|"o"|"u" => "a" ;
    _   => "ä"
    } ;

-----------------------
-- for Structural
-----------------------

caseTable : Number -> CommonNoun -> Case => Str = \n,cn -> 
  \\c => cn.s ! NCase n c ;

  mkDet : Number -> CommonNoun -> {
      s1,sp : Case => Str ;       -- minun kolme
      s2 : Str ;               -- -ni
      n : Number ;             -- Pl   (agreement feature for verb)
      isNum : Bool ;           -- True (a numeral is present)
      isPoss : Bool ;          -- True (a possessive suffix is present)
      isDef : Bool             -- True (verb agrees in Pl, Nom is not Part)
      } = \n, noun -> heavyDet {
    s1 = \\c => noun.s ! NCase n c ;
    s2 = [] ;
    n = n ;
    isNum, isPoss = False ;
    isDef = True  --- does this hold for all new dets?
    } ;

-- Here we define personal and relative pronouns.

  mkPronoun : (_,_,_,_,_ : Str) ->  Number -> Person -> 
    {s : NPForm => Str ; a : Agr} = 
    \mina, minun, minua, minuna, minuun, n, p ->
    let {
      minu = Predef.tk 2 minuna ;
      a    = Predef.dp 1 minuna
    } in 
    {s = table {
      NPCase Nom    => mina ;
      NPCase Gen    => minun ;
      NPCase Part   => minua ;
      NPCase Transl => minu + "ksi" ;
      NPCase Ess    => minuna ;
      NPCase Iness  => minu + ("ss" + a) ;
      NPCase Elat   => minu + ("st" + a) ;
      NPCase Illat  => minuun ;
      NPCase Adess  => minu + ("ll" + a) ;
      NPCase Ablat  => minu + ("lt" + a) ;
      NPCase Allat  => minu + "lle" ;
      NPCase Abess  => minu + ("tt" + a) ;
      NPCase Comit  => minu + "ga" ;
      NPCase Termin => minu + "ni" ;
      NPAcc         => Predef.tk 1 minun + "t"
      } ;
     a = Ag n p
    } ; 

  mkDemPronoun : (_,_,_,_,_ : Str) ->  Number -> 
    {s : NPForm => Str ; a : Agr} = 
    \tuo, tuon, tuota, tuona, tuohon, n ->
    let pro = mkPronoun tuo tuon tuota tuona tuohon n P3
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
  relPron : Number => Case => Str =
    let {jo = nForms2N (dSuo "jo")} in
    table {
      Sg => table {
        Nom => "joka" ;
        Gen => "jonka" ;
        c   => jo.s ! NCase Sg c
       } ; 
      Pl => table {
        Nom => "jotka" ;
        c   => "j" + (jo.s ! NCase Pl c)
        }
      } ;

  ProperName = {s : Case => Str} ;

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
