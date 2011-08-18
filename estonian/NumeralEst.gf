concrete NumeralFin of Numeral = CatFin [Numeral,Digits] **  open Prelude, ParadigmsFin, MorphoFin in {

-- Notice: possessive forms are not used. They get wrong, since every
-- part is made to agree in them.

flags optimize = all_subs ;

lincat 
  Sub1000000 = {s : CardOrd => Str ; n : MorphoFin.Number} ;
  Digit = {s : CardOrd => Str} ;
  Sub10, Sub100, Sub1000 = {s : NumPlace => CardOrd => Str ; n : MorphoFin.Number} ;

lin 
  num x = x ;
  n2 = co
    (nhn (mkSubst "a" "kaksi" "kahde" "kahte" "kahta" "kahteen" "kaksi" "kaksi"
    "kaksien" "kaksia" "kaksiin")) 
    (ordN "a" "kahdes") ; --- toinen
  n3 = co 
    (nhn (mkSubst "a" "kolme" "kolme" "kolme" "kolmea" "kolmeen" "kolmi" "kolmi"
    "kolmien" "kolmia" "kolmiin"))
    (ordN "a" "kolmas") ;
  n4 = co (mkN "nelj�") (ordN "�" "nelj�s") ;
  n5 = co (mkN "viisi" "viiden" "viisi�") (ordN "�" "viides") ;
  n6 = co (mkN "kuusi" "kuuden" "kuusia") (ordN "a" "kuudes") ; 
  n7 = co 
    (nhn (mkSubst "�" "seitsem�n" "seitsem�" "seitsem�" "seitsem��" 
    "seitsem��n" "seitsemi" "seitsemi" "seitsemien" "seitsemi�"
    "seitsemiin"))
    (ordN "�" "seitsem�s") ;
  n8 = co 
    (nhn (mkSubst "a" "kahdeksan" "kahdeksa" "kahdeksa" "kahdeksaa" 
    "kahdeksaan" "kahdeksi" "kahdeksi" "kahdeksien" "kahdeksia"
    "kahdeksiin"))
    (ordN "a" "kahdeksas") ;
  n9 = co
     (nhn (mkSubst "�" "yhdeks�n" "yhdeks�" "yhdeks�" "yhdeks��" 
    "yhdeks��n" "yhdeksi" "yhdeksi" "yhdeksien" "yhdeksi�" "yhdeksiin"))
     (ordN "�" "yhdeks�s") ;

  pot01 = 
   {s = table {
      NumAttr => \\_ => [] ; 
      NumIndep => yksiN.s
      } ;
    n = Sg
    } ;
  pot0 d = {n = Pl ; s = \\_ => d.s} ;
  pot110 =
   {s = \\_ => kymmenenN.s ;
    n = Pl
    } ;

  pot111 = {n = Pl ; s = \\_,c => yksiN.s ! c ++ BIND ++ "toista"} ; ---- yhdes
  pot1to19 d = {n = Pl ; s = \\_,c => d.s ! c ++ BIND ++ "toista"} ;
  pot0as1 n = n ;

  pot1 d = {n = Pl ; s = \\_,c => d.s ! c ++ BIND ++ kymmentaN.s ! c} ;
  pot1plus d e = {
    n = Pl ; 
    s = \\_,c => d.s ! c ++ BIND ++ kymmentaN.s ! c ++ BIND ++ e.s ! NumIndep ! c
    } ;
  pot1as2 n = n ;
  pot2 d = {n = Pl ; s = \\_,c => d.s ! NumAttr ! c ++ nBIND d.n ++ sataaN.s ! d.n ! c} ; ----
  pot2plus d e = {
    n = Pl ; 
    s = \\_,c => d.s ! NumAttr ! c ++ nBIND d.n ++ sataaN.s ! d.n ! c ++ 
                 BIND ++ e.s ! NumIndep ! c
    } ;
  pot2as3 n = {n = n.n  ; s = n.s ! NumIndep} ;
  pot3 d = {n = Pl ; s = \\c => d.s ! NumAttr ! c ++ nBIND d.n ++ tuhattaN.s ! d.n ! c} ; ----
  pot3plus d e = {
    n = Pl ;
    s = \\c => d.s ! NumAttr ! c ++ nBIND d.n ++ tuhattaN.s ! d.n ! c ++ e.s ! NumIndep ! c
    } ;

oper
  co : (c,o : {s : NForm => Str}) -> {s : CardOrd => Str} = \c,o -> {
    s = table {
      NCard nf => c.s ! nf ;
      NOrd  nf => o.s ! nf
      }
    } ;

  nBIND : Number -> Str = \n -> case n of {Sg => [] ; _ => BIND} ; -- no BIND after silent 1

-- Too much trouble to infer vowel, cf. "kuudes" vs. "viides".

  ordN : Str -> Str -> {s : NForm => Str} = \a,sadas -> 
    let
      sada = init sadas
    in
    mkN 
      sadas (sada + "nnen") (sada + "tt" + a) (sada + "nten" + a) (sada + "nteen")
      (sada + "nsien") (sada + "nsi" + a) (sada + "nsin" + a)
      (sada + "nsiss" + a) (sada + "nsiin") ;

param 
  NumPlace = NumIndep | NumAttr  ;

oper
  yksiN = co 
    (nhn (mkSubst "�" "yksi" "yhde" "yhte" "yht�" "yhteen" "yksi" "yksi" 
     "yksien" "yksi�" "yksiin")) 
    (ordN "�" "yhdes") ; ---- ensimm�inen
  kymmenenN = co 
    (nhn (mkSubst "�" "kymmenen" "kymmene" "kymmene" "kymment�" 
    "kymmeneen" "kymmeni" "kymmeni" "kymmenien" "kymmeni�" "kymmeniin")) 
    (ordN "�" "kymmenes") ;
  sataN = co 
    (mkN "sata") 
    (ordN "a" "sadas") ;

  tuhatN = co
    (mkN "tuhat" "tuhannen" "tuhatta" "ruhantena" "tuhanteen"
    "tuhansien" "tuhansia" "tuhansina" "tuhansissa" "tuhansiin")
    (ordN "a" "tuhannes")  ;

  kymmentaN =
   {s = table {
      NCard (NCase Sg Nom) => "kymment�" ;
      k => kymmenenN.s ! k
      }
    } ;

  sataaN : {s : MorphoFin.Number => CardOrd => Str} = {s = table {
    Sg => sataN.s ;
    Pl => table {
      NCard (NCase Sg Nom) => "sataa" ;
      k => sataN.s ! k
      }
    } 
  } ;

  tuhattaN = {s = table {
    Sg => tuhatN.s ;
    Pl => table {
      NCard (NCase Sg Nom) => "tuhatta" ;
      k => tuhatN.s ! k
      }
    }
  } ;


  lincat 
    Dig = TDigit ;

  lin
    IDig d = d ; 

    IIDig d i = {
      s = \\o => d.s ! NCard (NCase Sg Nom) ++ i.s ! o ;
      n = Pl
    } ;

    D_0 = mkDig "0" ;
    D_1 = mk3Dig "1" "1." MorphoFin.Sg ;
    D_2 = mkDig "2" ;
    D_3 = mkDig "3" ;
    D_4 = mkDig "4" ;
    D_5 = mkDig "5" ;
    D_6 = mkDig "6" ;
    D_7 = mkDig "7" ;
    D_8 = mkDig "8" ;
    D_9 = mkDig "9" ;

  oper
    mk2Dig : Str -> Str -> TDigit = \c,o -> mk3Dig c o MorphoFin.Pl ;
    mkDig : Str -> TDigit = \c -> mk2Dig c (c + ".") ;

    mk3Dig : Str -> Str -> MorphoFin.Number -> TDigit = \c,o,n -> {
      s = table {NCard _ => c ; NOrd _ => o} ;
      n = n
      } ;

    TDigit = {
      n : MorphoFin.Number ;
      s : CardOrd => Str
    } ;

}

