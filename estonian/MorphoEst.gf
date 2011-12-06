--# -path=.:../common:../prelude

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

  -- 2-syllable a/A, o/O, u/y
  dUkko : (_,_ : Str) -> NForms = \ukko,ukon ->
      let
        o   = last ukko ;
        a   = vowHarmony o ;
        ukk = init ukko ;
        uko = init ukon ;
        uk  = init uko ;
        ukkoja = case <ukko : Str> of {
          _ + "A" =>                        -- kylA,kyliA,kylien,kylissA,kyliin 
             <ukk + "iA", ukk + "ien", ukk, uk, ukk + "iin"> ;
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

  -- 3-syllable a/A/o/O
  dSilakka : (_,_,_ : Str) -> NForms = \silakka,silakan,silakoita ->
    let
      o = last silakka ;
      a = getHarmony o ;
      silakk = init silakka ;
      silaka = init silakan ;
      silak  = init silaka ;
      silakkaa = silakka + case o of {
        "o" | "O" => "t" + a ;  -- radiota
        _ => a                  -- sammakkoa
        } ;
      silakoiden = case <silakoita : Str> of {
        _ + "i" + ("a" | "A") =>                    -- asemia
          <silakka+a, silakk + "ien", silakk, silak, silakk + "iin"> ;
        _ + O@("o" | "O" | "u" | "y" | "e") + ("ja" | "jA") =>        -- pasuunoja
          <silakka+a,silakk+O+"jen",silakk+O, silak+O, silakk +O+ "ihin"> ;
        _ + O@("o" | "O" | "u" | "y" | "e") + ("ita" | "itA") =>      -- silakoita
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
            "d" | "l" | "n" | "r" =>   -- suden,sutta ; jAlsi ; kansi ; hirsi
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
          } ;                                   ---- pieni,pientA; uni,unta
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
           <"n","tA","nA","hen","iden","itA","inA","issA","ihin"> ;
        "F" | "L" | "M" | "N" | "R" | "S" | "X" => 
           <"n","AA","nA","AAn","ien","iA","inA","issA","iin"> ;
        "H" | "K" | "O" | "A" => 
           <"n","ta","na","hon","iden","ita","ina","issa","ihin"> ;
        "I" | "J" => 
           <"n","tA","nA","hin","iden","itA","inA","issA","ihin"> ;
        "Q" | "U" => 
           <"n","ta","na","hun","iden","ita","ina","issa","ihin"> ;
        "Z" => 
           <"n","aa","na","aan","ojen","oja","oina","oissa","oihin"> ;
        "A" => 
           <"n","tA","nA","hAn","iden","itA","inA","issA","ihin"> ;
        "O" => 
           <"n","tA","nA","hOn","iden","itA","inA","issA","ihin"> ;
        "Y" => 
           <"n","tA","nA","hyn","iden","itA","inA","issA","ihin"> ;
        _ => Predef.error (["illegal abbreviation"] ++ SDP)
        } ;
    in nForms10
      SDP (SDP + ":" + c.p1) (SDP + ":" + c.p2) (SDP + ":" + c.p3) 
      (SDP + ":" + c.p4) (SDP + ":" + c.p5) (SDP + ":" + c.p6) 
      (SDP + ":" + c.p7) (SDP + ":" + c.p8) (SDP + ":" + c.p9) ;

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
      (juo + "v" + a + "d")
      (juo + "k" + a + a)
      (juoda + a + "n")
      (joi + "n")
      (joi)
      (joi + "si")
      (juo + "n" + u + "t")
      (juo + "t" + u)
      (juo + "nee") ;

  -- VVS: 37 võima
  cSaada : (_ : Str) -> VForms = \saada ->
    let
      saa = Predef.tk 2 saada;
      sa = Predef.tk 3 saada;
    in vForms12
      saada
      (saa + "n")
      (saa + "b")
      (saa + "vad")
      (saa + "ge") -- Imper Pl (2nd person? 'saage')
      (saa + "an") --5?
      (sa + "in")
      (sa + "ite")
      (saa + "ks") -- Condit Sg P3
      (saa + "nud") --9?
      (saa + "tu") --10?
      (saa + "nee"); -- 11?

  -- VVS: 27 elama
  cElada : (_ : Str) -> VForms = \elada ->
    let
      ela = Predef.tk 2 elada;
    in vForms12
      elada
      (ela + "n")
      (ela + "b")
      (ela + "vad")
      (ela + "ge") -- Imper Pl
      (elada + "an") --5?
      (ela + "sin")
      (ela + "site")
      (ela + "ks") -- Condit Sg P3
      (ela + "nud") --9?
      (ela + "tu") --10?
      (ela + "nee"); -- 11?

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

    -- TODO: does not exist in Estonian
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
      tulge = vh ! 4 ; 
      tullaan = vh ! 5 ; 
      tulin = vh ! 6 ; 
      tuli = vh ! 7 ;
      tulisi = vh ! 8 ;
      tullut = vh ! 9 ;
      tultu = vh ! 10 ;
      tullun = vh ! 11 ;
      tule_ = init tulen ;
      tuli_ = init tulin ;
      a = last tulge ;
      tulgu = (init tulge) + "u" ;
      tulko = Predef.tk 2 tulge + (ifTok Str a "a" "o" "ö") ;
      tullee = Predef.tk 2 tullut + "ee" ;
      tulleen = (nForms2N (dOttanut tullut)).s ;
      tullu : Str = weakGrade tultu ;
      tullun  = (nForms2N (dUkko tultu (tullu + "n"))).s ; 
      tulema = Predef.tk 2 tulla + "ma" ;
    in
    {s = table {
      Inf Inf1 => tulla ;
      Presn Sg P1 => tule_ + "n" ;
      Presn Sg P2 => tule_ + "d" ;
      Presn Sg P3 => tulee ;
      Presn Pl P1 => tule_ + "me" ;
      Presn Pl P2 => tule_ + "te" ;
      Presn Pl P3 => tulevat ;
      Impf Sg P1  => tuli_ + "n" ;   --# notpresent
      Impf Sg P2  => tuli_ + "d" ;  --# notpresent
      Impf Sg P3  => tuli ;  --# notpresent
      Impf Pl P1  => tuli_ + "me" ;  --# notpresent
      Impf Pl P2  => tuli_ + "te" ;  --# notpresent
      Impf Pl P3  => tuli_ + "d" ;  --# notpresent
      Condit Sg P1 => tulisi + "in" ;  --# notpresent
      Condit Sg P2 => tulisi + "id" ;  --# notpresent
      Condit Sg P3 => tulisi ;  --# notpresent
      Condit Pl P1 => tulisi + "ime" ;  --# notpresent
      Condit Pl P2 => tulisi + "ite" ;  --# notpresent
      Condit Pl P3 => tulisi + "id" ;  --# notpresent
      Imper Sg   => tule_ ; -- tule
      Imper Pl   => tulge ; -- tulge
      ImperP3 Sg => tulgu ; -- ta tulgu ?
      ImperP3 Pl => tulgu ; -- nad tulgu ?
      ImperP1Pl  => tulgu ; -- me tulgu ?
      ImpNegPl   => tulge ; -- ärge tulge ?
      Pass True  => tullaan ;
      Pass False => Predef.tk 2 tullaan ;
      PastPartAct (AN n)  => tulleen ! n ;
      PastPartAct AAdv    => tullee + "sti" ;
      PastPartPass (AN n) => tullun ! n ;
      PastPartPass AAdv   => tullu + "sti" ;
      Inf Inf3Transl => tulema + "ks" ; -- -maks (missing in Finnish)
      Inf Inf3Iness => tulema + "s" ;
      Inf Inf3Elat  => tulema + "st" ;
      Inf Inf3Abess => tulema + "ta"
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

  -- input forms: Nom, Gen, Part
  -- Note that the Fin version required 5 input forms, the
  -- Est pronouns thus seem to be much simpler.
  -- TODO: meiesse/teiesse -> meisse/teisse
  -- TODO: remove NPAcc?
  mkPronoun : (_,_,_ : Str) -> Number -> Person ->
    {s : NPForm => Str ; a : Agr} = 
    \mina, minu, mind, n, p ->
    let {
      a = "a" -- currently not used
    } in 
    {s = table {
      NPCase Nom    => mina ;
      NPCase Gen    => minu ;
      NPCase Part   => mind ;
      NPCase Transl => minu + "ks" ;
      NPCase Ess    => minu + "na" ;
      NPCase Iness  => minu + "s" ;
      NPCase Elat   => minu + "st" ;
      NPCase Illat  => minu + "sse" ;
      NPCase Adess  => minu + "l" ;
      NPCase Ablat  => minu + "lt" ;
      NPCase Allat  => minu + "le" ;
      NPCase Abess  => minu + "ta" ;
      NPCase Comit  => minu + "ga" ;
      NPCase Termin => minu + "ni" ;
      NPAcc         => Predef.tk 1 minu + "t"
      } ;
     a = Ag n p
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
  relPron : Number => Case => Str =
    let {jo = nForms2N (dLuu "jo")} in
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
