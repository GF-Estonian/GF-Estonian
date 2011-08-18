--# -path=.:alltenses

resource Kotus = open MorphoFin, Prelude in {

-- interpretations of paradigms in KOTUS word list, used in DictFin.

oper vowelHarmony = vowHarmony ;

oper

  d01 : Str -> NForms -- 1780 �ljy
    = \s -> dUkko s (s + "n") ;
  d01A : Str -> NForms -- 166 y�kk�
    = \s -> dUkko s (weakGrade s + "n") ;
  d02 : Str -> NForms -- 1189 ��ntely
    = \s -> dSilakka s (s + "n") (s + "j" + getHarmony (last s)) ;
  d03 : Str -> NForms -- 481 ��nti�
    = \s -> dSilakka s (s + "n") (s + "it" + vowelHarmony s) ;
  d04A : Str -> NForms -- 273 �p�rikk�
    = \s -> let ws = weakGrade s in 
      dSilakka s (ws + "n") (ws + "it" + getHarmony (last s)) ;
  d05 : Str -> NForms -- 3212 �ljymaali
    = \s -> case last s of {
              "i" => dPaatti s (s + "n") ;
              _   => dUnix s
              } ;
  d05A : Str -> NForms -- 1959 �yl�tti
    = \s -> dPaatti s (weakGrade s + "n") ;
  d06 : Str -> NForms -- 1231 �ykk�ri
    = \s -> dTohtori s ;
  d07 : Str -> NForms -- 81 vuoksi
    = \s -> dArpi s (init s + "en") ;
  d07A : Str -> NForms -- 70 v�ki
    = \s -> dArpi s (init (weakGrade s) + "en") ;
  d08 : Str -> NForms -- 99 � la carte
    = \s -> dNukke s (s + "n") ;
  d08A : Str -> NForms -- 5 vinaigrette
    = \s -> dNukke s (weakGrade s + "n") ;
  d09 : Str -> NForms -- 696 ��riraja
    = \s -> let a = last s in dSilakka s         
              (s + "n")
              (init s + case a of {"a" => "o" ; _ => "�"} + "j" + a) ;
  d09A : Str -> NForms -- 1040 ��niraita
    = \s -> let a = last s in dSilakka s         
              (weakGrade s + "n")
              (init s + case a of {"a" => "o" ; _ => "�"} + "j" + a) ;
  d10 : Str -> NForms -- 2119 ��nitt�j�
    = \s -> dSilakka s (s + "n") (init s + "i" + vowelHarmony (last s)) ;
  d10A : Str -> NForms -- 284 �nkk�
    = \s -> dSilakka s (weakGrade s + "n") (init s + "i" + vowelHarmony (last s)) ;
  d11 : Str -> NForms -- 46 �deema
    = \s -> dSilakka s (weakGrade s + "n") (init s + "i" + vowelHarmony (last s)) ;
  d12 : Str -> NForms -- 1125 �rin�
    = \s -> let a = vowelHarmony (last s) in 
      dSilakka s (s + "n") 
        (init s + case a of {"a" => "o" ; _ => "�"} + "it" + a) ;
  d13 : Str -> NForms -- 157 virtaska
    = \s -> let a = vowelHarmony (last s) in 
      dSilakka s (s + "n") 
        (init s + case a of {"a" => "o" ; _ => "�"} + "j" + a) ;
  d14A : Str -> NForms -- 244 �t�kk�
    = \s -> let a = vowelHarmony (last s) ; ws = weakGrade s in 
      dSilakka s (ws + "n") 
        (init ws + case a of {"a" => "o" ; _ => "�"} + "it" + a) ;
  d15 : Str -> NForms -- 170 �re�
    = dKorkea ;
  d16 : Str -> NForms -- 2 kumpikin --?
    = \s -> let kumpi = Predef.take 5 s ; kin = Predef.drop 5 s in 
         \\i => (dSuurempi kumpi ! i + kin) ;
  d16A : Str -> NForms -- 20 ylempi
    = dSuurempi ;
  d17 : Str -> NForms -- 38 virkkuu
    = dPaluu ;
  d18 : Str -> NForms -- voi, tee, s��
    = dPuu ;
  d19 : Str -> NForms -- 6 y�
    = dSuo  ;
  d20 : Str -> NForms -- 46 voodoo
    = dPaluu ;
  d21 : Str -> NForms -- 22 tax-free --? ros�
    = dPuu ;
  d22 : Str -> NForms -- 13 tournedos
    = \s -> nForms10
      s (s + "'n") (s + "'ta") (s + "'na") (s + "'hon")
      (s + "'iden") (s + "'ita") (s + "'ina") (s + "'issa") (s + "'ihin") ;
  d23 : Str -> NForms -- 9 vuohi
    = \s -> dArpi s (init s + "en") ;
  d24 : Str -> NForms -- 20 uni
    = \s -> dArpi s (init s + "en") ;
  d25 : Str -> NForms -- 9 tuomi
    = \s -> dArpi s (init s + "en") ;
  d26 : Str -> NForms -- 113 ��ri
    = \s -> dArpi s (init s + "en") ;
  d27 : Str -> NForms -- 23 vuosi
    = \s -> dArpi s (Predef.tk 2 s + "den") ;
  d28 : Str -> NForms -- 13 virsi
    = \s -> dArpi s (Predef.tk 2 s + "ren") ;
  d28A : Str -> NForms -- 1 j�lsi
    = \s -> dArpi s (Predef.tk 2 s + "len") ;
  d29 : Str -> NForms -- 1 lapsi
    = \s -> let lapsi = dArpi s (init s + "en") in 
       table {2 => Predef.tk 3 s + "ta" ; i => lapsi ! i} ;
  d30 : Str -> NForms -- 2 veitsi
    = \s -> let lapsi = dArpi s (init s + "en") in 
       table {2 => Predef.tk 3 s + "st�" ; i => lapsi ! i} ;
  d31 : Str -> NForms -- 3 yksi
    = \s -> let 
        y = Predef.tk 3 s ;
        a = vowelHarmony y
      in nForms10
        s (y + "hden") (y + "ht" + a) (y + "hten" + a) (y + "hteen")
        (s + "en") (s + a) (s + "n" + a) (s + "ss" + a) (s + "in") ;
  d32 : Str -> NForms -- 20 uumen
    = \s -> dPiennar s (s + "en") ;
  d32A : Str -> NForms -- 54 yst�v�t�r
    = \s -> dPiennar s (strongGrade (init s) + last s + "en") ;
  d33 : Str -> NForms -- 168 v�istin
    = \s -> dLiitin s (init s + "men") ;
  d33A : Str -> NForms -- 181 yllytin
    = \s -> dLiitin s (strongGrade (init s) + "men") ;
  d34 : Str -> NForms -- 1 alaston
    = \s -> let alastom = init s in 
      nForms10
        s (alastom + "an") (s + "ta") (alastom + "ana") (alastom + "aan")
        (alastom + "ien") (alastom + "ia") (alastom + "ina") (alastom + "issa")
        (alastom + "iin") ;
  d34A : Str -> NForms -- 569 ��ret�n
    = dOnneton ;
  d35A : Str -> NForms -- 1 l�mmin
    = \s -> let l�mpim = strongGrade (init s) + "m" in
      nForms10
        s (l�mpim + "�n") (s + "t�") (l�mpim + "�n�") (l�mpim + "��n")
        (l�mpim + "ien") (l�mpim + "i�") (l�mpim + "in�") (l�mpim + "iss�")
        (l�mpim + "iin") ;
  d36 : Str -> NForms -- 11 ylin
    = dSuurin ;
  d37 : Str -> NForms -- 1 vasen
    = \s -> let vasem = init s + "m" in 
      nForms10
        s (vasem + "man") (s + "ta") (vasem + "pana") (vasem + "paan")
        (vasem + "pien") (vasem + "pia") (vasem + "pina") (vasem + "missa")
        (vasem + "piin") ;
  d38 : Str -> NForms -- 4195 �ykk�rim�inen
    = dNainen ;
  d39 : Str -> NForms -- 2730 �r�hdys
    = dJalas ;
  d40 : Str -> NForms -- 2482 �ykk�rim�isyys
    = dLujuus  ;
  d41 : Str -> NForms -- 127 �yr�s
    = \s -> let is = init s in dRae s (is + last is + "n") ;
  d41A : Str -> NForms -- 401 �ljykangas
    = \s -> let is = init s in dRae s (strongGrade is + last is + "n") ;
  d42 : Str -> NForms -- 1 mies
    = \s -> let mieh = init s + "s" in 
      nForms10
        s (mieh + "en") (s + "t�") (mieh + "en�") (mieh + "een")
        (s + "ten") (mieh + "i�") (mieh + "in�") (mieh + "iss�")
        (mieh + "iin") ;
  d43 : Str -> NForms -- 11 tiehyt
    = \s -> dRae s (init s + "en") ;
  d43A : Str -> NForms -- 1 immyt
    = \s -> dRae s (strongGrade (init s) + "en") ;
  d44 : Str -> NForms -- 1 kev�t
    = \s -> let kev� = init s in 
      nForms10
        s (kev� + "�n") (s + "t�") (kev� + "�n�") (kev� + "�seen")
        (s + "iden") (kev� + "it�") (kev� + "in�") (kev� + "iss�")
        (kev� + "isiin") ;
  d45 : Str -> NForms -- 23 yhdes
    = \s -> let yhde = init s ; a = vowelHarmony s in 
      nForms10
        s (yhde + "nnen") (yhde + "tt" + a) (yhde + "nten" + a) (yhde + "nteen")
        (yhde + "nsien") (yhde + "nsi" + a) (yhde + "nsin" + a) (yhde + "nsiss" + a)
        (yhde + "nsiin") ;
  d46 : Str -> NForms -- 1 tuhat
    = \s -> let tuha = init s ; a = vowelHarmony s in 
      nForms10
        s (tuha + "nnen") (tuha + "tt" + a) (tuha + "nten" + a) (tuha + "nteen")
        (tuha + "nsien") (tuha + "nsi" + a) (tuha + "nsin" + a) (tuha + "nsiss" + a)
        (tuha + "nsiin") ;
  d47 : Str -> NForms -- 46 ylirasittunut
    = dOttanut ;
  d48 : Str -> NForms -- 346 �p�re
    = \s -> dRae s (s + last s + "n") ;
  d48A : Str -> NForms -- 481 ��nne
    = \s -> dRae s (strongGrade s + "en") ;
  d49 : Str -> NForms -- 31 vempele
    = \s -> case last s of {
         "e" => dRae s (s + "en") ;
         _ => dPiennar s (s + "en")
        } ;
  d49A : Str -> NForms -- 11 vemmel
    = \s -> dPiennar s (strongGrade (init s) + "len") ;
{-
  d50 : Str -> NForms -- 520 v��r�s��ri
    = \s ->  ;
  d51 : Str -> NForms -- 62 vierasmies
    = \s ->  ;
-}
  c52 : Str -> VForms -- 667 �rjy�
    = \s -> cHukkua s (init s + "n") ;
  c52A : Str -> VForms -- 1568 �ljyynty�
    = \s -> cHukkua s (weakGrade (init s) + "n")  ;
  c53 : Str -> VForms -- 605 ��nest��
    = \s -> let ott = Predef.tk 2 s in 
            cOttaa s (init s + "n") (ott + "in") (ott + "i")  ;
  c53A : Str -> VForms -- 2121 �r�ht��
    = \s -> let ota = weakGrade (init s) in
            cOttaa s (ota + "n") (init ota + "in") (Predef.tk 2 s + "i")  ;
  c54 : Str -> VForms -- 2 pieks��
    = \s -> let ott = Predef.tk 2 s in 
            cOttaa s (init s + "n") (ott + "in") (ott + "i")  ;
  c54A : Str -> VForms -- 316 ��nt��
    = \s -> let ota = weakGrade (init s) ; o = Predef.tk 2 ota in
            cOttaa s (ota + "n") (o + "sin") (o + "si")  ;
  c55A : Str -> VForms -- 7 ylt��
    = c54A  ; --? diff: variation ylti/ylsi
  c56 : Str -> VForms -- 22 valaa
    = \s -> let val = Predef.tk 2 s in 
            cOttaa s (init s + "n") (val + "oin") (val + "oi")  ; -- never �
  c56A : Str -> VForms -- 28 virkkaa
    = \s -> let ota = weakGrade (init s) ; ot = init ota in
            cOttaa s (ota + "n") (ot + "oin") (ot + "oi")  ;
  c57A : Str -> VForms -- 3 saartaa
    = c56A ; --? diff: saartoi/saarsi
  c58 : Str -> VForms -- 13 suitsea
    = \s -> cHukkua s (init s + "n") ;
  c58A : Str -> VForms -- 19 tunkea
    = \s -> cHukkua s (weakGrade (init s) + "n") ;
  c59A : Str -> VForms -- 1 tuntea
    = \s -> let tunte = init s ; tunne = weakGrade tunte ; tuns = Predef.tk 2 tunte + "s" in
      vForms12 s (tunne + "n") (tunte + "e") (tunte + "vat") (tunte + "kaa") (tunne + "taan")
        (tuns + "in") (tuns + "i") (init tunte + "isi") (tunte + "nut") (tunne + "ttu")
        (tunte + "nee") ; -- just one verb
  c60A : Str -> VForms -- 1 l�hte�
    = c58A ; --? diff l�hti/l�ksi, just one verb
  c61 : Str -> VForms -- 249 �yski�
    = \s -> cHukkua s (init s  + "n") ;
  c61A : Str -> VForms -- 153 v��ntelehti�
    = \s -> cHukkua s (weakGrade (init s)  + "n") ;
  c62 : Str -> VForms -- 684 �ykk�r�id�
    = \s -> cJuoda s ;
  c63 : Str -> VForms -- 3 saada
    = c62  ;
  c64 : Str -> VForms -- 8 vied�
    = c62  ;
  c65 : Str -> VForms -- 1 k�yd�
    = \s -> let kay = Predef.tk 2 s ; kavi = init kay + "vi" in
      vForms12 s (kay + "n") kay (kay + "v�t") (kay + "k��") (kay + "d��n")
        (kavi + "n") kavi (kavi + "si") (kay + "nyt") (kay + "tty")
        (kay + "nee") ; -- just one verb
  c66 : Str -> VForms -- 268 �rist�
    = \s -> cKuunnella s (Predef.tk 2 s + "in") ;
  c66A : Str -> VForms -- 3 vavista
    = \s -> cKuunnella s (strongGrade (Predef.tk 3 s) + "sin") ;
  c67 : Str -> VForms -- 704 �llistell�
    = \s -> cKuunnella s (Predef.tk 2 s + "in") ;
  c67A : Str -> VForms -- 634 ��nnell�
    = \s -> cKuunnella s (strongGrade (Predef.tk 3 s) + "lin") ;
  c68 : Str -> VForms -- 49 viheri�id�
    = c62 ; -- diff viheri�in/viheri�itsen
  c69 : Str -> VForms -- 48 villit�
    = \s -> cHarkita s ;
  c70 : Str -> VForms -- 3 sy�st�
    = \s -> cJuosta s (Predef.tk 3 s + "ksen") ;
  c71 : Str -> VForms -- 2 tehd�
    = \s -> let te = Predef.tk 3 s in
      vForms12 s (te + "en") (te + "kee") (te + "kev�t") (te + "hk��") (te + "hd��n")
        (te + "en") (te + "ki") (te + "kisi") (te + "hnyt") (te + "hty")
        (te + "hnee") ; -- just two verbs: n�hd�, tehd�
  c72 : Str -> VForms -- 93 ylet�
    = \s -> cValjeta s (Predef.tk 2 s + "ni") ;
  c72A : Str -> VForms -- 52 yhdet�
    = \s -> cValjeta s (strongGrade (Predef.tk 2 s) + "ni") ;
  c73 : Str -> VForms -- 600 �kseerata
    = \s -> cPudota s (Predef.tk 2 s + "si") ;
  c73A : Str -> VForms -- 313 �nk�t�
    = \s -> cPudota s (strongGrade (Predef.tk 2 s) + "si") ;
  c74 : Str -> VForms -- 99 �ljyt�
    = \s -> cPudota s (Predef.tk 2 s + "si") ;
  c74A : Str -> VForms -- 72 �nget�
    = \s -> cPudota s (strongGrade (Predef.tk 2 s) + "si") ;
  c75 : Str -> VForms -- 39 virit�
    = \s -> cPudota s (Predef.tk 2 s + "si") ;
  c75A : Str -> VForms -- 9 siit�
    = \s -> cPudota s (strongGrade (Predef.tk 2 s) + "si") ;
  c76A : Str -> VForms -- 2 tiet��
    = \s -> let tieta = init s ; tieda = weakGrade tieta ; ties = Predef.tk 2 tieta + "s" in 
      cOttaa s (tieda + "n") (ties + "in") (ties + "i") ; -- only tietaa, taitaa
-- defective verbs
  c77 : Str -> VForms -- 3 vipajaa
    = c56A ; ----
  c78 : Str -> VForms -- 31 �hk��
    = c56A ; ----
  c78A : Str -> VForms -- 1 tuikkaa
    = c56A ; ----
  c99 : Str -> Str -- 5453 �ykk�rim�isesti
    = \s -> s ;

  c101 : Str -> Str -- pronouns etc
    = c99 ; -- dummy

-- compound nouns, latter part inflected
  compoundNK : Str -> NForms -> NForms = \x,y -> 
    \\v => x + y ! v ;

--- this is a lot slower
  fcompoundNK : (Str -> NForms) -> Str -> Str -> NForms = \d,x,y -> 
    let ys = d y in \\v => x + ys ! v ;

}

