concrete StructuralEst of Structural = CatEst **
  open MorphoEst, ParadigmsEst, (X = ConstructX), MakeStructuralEst, Prelude in {

  flags optimize=all ; coding=utf8 ;

  lin
  above_Prep = postGenPrep "yläpuolella" ;
  after_Prep = postGenPrep "jälkeen" ;

  all_Predet = {s = \\n,c =>
    let
      kaiket = caseTable n ((mkN "kaikki" "kaiken" "kaikkena"))
    in
    case npform2case n c of {
      Nom => "kaikki" ;
      k => kaiket ! k
      }
    } ;
  almost_AdA, almost_AdN = ss "peaaegu" ;
  although_Subj = ss "kuigi" ;
  always_AdV = ss "alati" ;
  and_Conj = {s1 = [] ; s2 = "ja" ; n = Pl} ;
  because_Subj = ss "sellepärast" ;
  before_Prep = prePrep partitive "ennen" ;
  behind_Prep = postGenPrep "takana" ;
  between_Prep = postGenPrep "välissä" ;
  both7and_DConj = sd2 "sekä" "että" ** {n = Pl} ;
  but_PConj = ss "aga" ;
  by8agent_Prep = postGenPrep "toimesta" ;
  by8means_Prep = casePrep adessive ;
  can8know_VV = mkVV (mkV "osata" "osasi") ;
  can_VV = mkVV (mkV "voida" "voi") ;
  during_Prep = postGenPrep "aikana" ;
  either7or_DConj = sd2 "joko" "tai" ** {n = Sg} ;
  everybody_NP = makeNP (mkN "jokainen") Sg ;
  every_Det = mkDet Sg (mkN "jokainen") ;
  everything_NP = makeNP (((mkN "kaikki" "kaiken" "kaikkena")) **
    {lock_N = <>}) Sg ;
  everywhere_Adv = ss "kõikjal" ;
  few_Det  = mkDet Sg (mkN "harva") ;
---  first_Ord = {s = \\n,c => (mkN "ensimmäinen").s ! NCase n c} ;
  for_Prep = casePrep allative ;
  from_Prep = casePrep elative ;
  he_Pron = mkPronoun "hän" "hänen" "häntä"  "hänenä" "häneen" Sg P3 ;
  here_Adv = ss "siin" ;
  here7to_Adv = ss "siia" ;
  here7from_Adv = ss "siit" ;
  how_IAdv = ss "kuidas" ;
  how8much_IAdv = ss "kui palju" ;
  how8many_IDet =
    {s = \\c => "kuinka" ++ (mkN "moni" "monia").s ! NCase Sg c ; n = Sg ; isNum = False} ;
  if_Subj = ss "kui" ;
  in8front_Prep = postGenPrep "edessä" ;
  i_Pron  = mkPronoun "minä" "minun" "minua" "minuna" "minuun" Sg P1 ;
  in_Prep = casePrep inessive ;
  it_Pron = {
    s = \\c => pronSe.s ! npform2case Sg c ;
    a = agrP3 Sg ;
    isPron = False
    } ;
  less_CAdv = X.mkCAdv "vähemmän" "kuin" ;
  many_Det = mkDet Sg (mkN "moni" "monia") ;
  more_CAdv = X.mkCAdv "enemmän" "kuin" ;
  most_Predet = {s = \\n,c => (nForms2N (dSuurin "useinta")).s ! NCase n (npform2case n c)} ;
  much_Det = mkDet Sg {s = \\_ => "paljon"} ;
  must_VV = mkVV (caseV genitive (mkV "täytyä")) ;
  no_Utt = ss "ei" ;
  on_Prep = casePrep adessive ;
---  one_Quant = mkDet Sg  DEPREC
  only_Predet = {s = \\_,_ => "vain"} ;
  or_Conj = {s1 = [] ; s2 = "tai" ; n = Pl} ;
  otherwise_PConj = ss "muidu" ;
  part_Prep = casePrep partitive ;
  please_Voc = ss ["ole hyvä"] ; --- number
  possess_Prep = casePrep genitive ;
  quite_Adv = ss "üsna" ;
  she_Pron = mkPronoun "hän" "hänen" "häntä"  "hänenä" "häneen" Sg P3 ;
  so_AdA = ss "nii" ;
  somebody_NP = {
    s = \\c => jokuPron ! Sg ! npform2case Sg c ;
    a = agrP3 Sg ;
    isPron = False
    } ;
  someSg_Det = heavyDet {
    s1 = jokuPron ! Sg ;
    s2 = [] ;
    isNum,isPoss = False ; isDef = True ; n = Sg
    } ;
  somePl_Det = heavyDet {
    s1 = jokuPron ! Pl ;
    s2 = [] ; isNum,isPoss = False ; isDef = True ;
    n = Pl
    } ;
  something_NP = {
    s = \\c => jokinPron ! Sg ! npform2case Sg c ;
    a = agrP3 Sg ;
    isPron = False
    } ;
  somewhere_Adv = ss "kuskil" ;
  that_Quant = heavyQuant {
    s1 = table (MorphoEst.Number) {
          Sg => table (MorphoEst.Case) {
            c => (mkPronoun "tuo" "tuon" "tuota" "tuona" "tuohon" Sg P3).s ! NPCase c
            } ;
          Pl => table (MorphoEst.Case) {
            c => (mkPronoun "nuo" "noiden" "noita" "noina" "noihin" Sg P3).s ! NPCase c
            }
          } ;
    s2 = [] ; isNum,isPoss = False ; isDef = True ;
    } ;
  that_Subj = ss "et" ;
  there_Adv = ss "seal" ;
  there7to_Adv = ss "sinna" ;
  there7from_Adv = ss "sealt" ;
  therefore_PConj = ss "sellepärast" ;
  they_Pron = mkPronoun "he" "heidän" "heitä" "heinä" "heihin"  Pl P3 ; --- ne
  this_Quant = heavyQuant {
    s1 = table (MorphoEst.Number) {
          Sg => table (MorphoEst.Case) {
            c => (mkPronoun "tämä" "tämän" "tätä" "tänä" "tähän" Sg P3).s ! NPCase c
            } ;
          Pl => table (MorphoEst.Case) {
            c => (mkPronoun "nämä" "näiden" "näitä" "näinä" "näihin" Sg P3).s ! NPCase c
            }
          } ;
    s2 = [] ; isNum,isPoss = False ; isDef = True ;
    } ;
  through_Prep = postGenPrep "kautta" ;
  too_AdA = ss "liiga" ;
  to_Prep = casePrep illative ; --- allative
  under_Prep = postGenPrep "alla" ;
  very_AdA = ss "eriti" ;
  want_VV = mkVV (mkV "tahtoa") ;
  we_Pron = mkPronoun "me" "meidän" "meitä" "meinä" "meihin" Pl P1 ;
  whatPl_IP = {
    s = table {NPAcc => "mitkä" ; c => mikaInt ! Pl ! npform2case Pl c} ;
    n = Pl
    } ;
  whatSg_IP = {
    s = \\c => mikaInt ! Sg ! npform2case Sg c ;
    n = Sg
    } ;
  when_IAdv = ss "kui" ;
  when_Subj = ss "kui" ;
  where_IAdv = ss "kus" ;
  which_IQuant = {
    s = mikaInt
    } ;
  whoSg_IP = {
    s = table {NPAcc => "kenet" ; c => kukaInt ! Sg ! npform2case Sg c} ;
    n = Sg
    } ;
  whoPl_IP = {
    s = table {NPAcc => "ketkä" ; c => kukaInt ! Pl ! npform2case Pl c} ;
    n = Pl
    } ;
  why_IAdv = ss "miks" ;
  without_Prep = prePrep partitive "ilman" ;
  with_Prep = postGenPrep "kanssa" ;
  yes_Utt = ss "jah" ;
  youSg_Pron = mkPronoun "sinä" "sinun" "sinua" "sinuna" "sinuun"  Sg P2 ;
  youPl_Pron = mkPronoun "te" "teidän" "teitä" "teinä" "teihin"  Pl P2 ;
  youPol_Pron =
    let p = mkPronoun "te" "teidän" "teitä" "teinä" "teihin"  Pl P2 in
    {s = p.s ; a = AgPol} ;

oper
  jokuPron : MorphoEst.Number => (MorphoEst.Case) => Str =
    let
      kui = mkN "kuu"
    in
    table {
      Sg => table {
        Nom => "joku" ;
        Gen => "jonkun" ;
        c => relPron ! Sg ! c + "ku" + Predef.drop 3 (kui.s ! NCase Sg c)
       } ;
      Pl => table {
        Nom => "jotkut" ;
        c => relPron ! Pl ! c + kui.s ! NCase Pl c
        }
      } ;

  jokinPron : MorphoEst.Number => (MorphoEst.Case) => Str =
    table {
      Sg => table {
        Nom => "jokin" ;
        Gen => "jonkin" ;
        c => relPron ! Sg ! c + "kin"
       } ;
      Pl => table {
        Nom => "jotkin" ;
        c => relPron ! Pl ! c + "kin"
        }
      } ;

  mikaInt : MorphoEst.Number => (MorphoEst.Case) => Str =
    let {
      mi  = mkN "mi"
    } in
    table {
      Sg => table {
        Nom => "mikä" ;
        Gen => "minkä" ;
        Part => "mitä" ;
        c   => mi.s ! NCase Sg c
       } ;
      Pl => table {
        Nom => "mitkä" ;
        Gen => "minkä" ;
        Part => "mitä" ;
        c   => mi.s ! NCase Sg c
        }
      } ;

  kukaInt : MorphoEst.Number => (MorphoEst.Case) => Str =
    let
      kuka = mkN "kes" "kelle" "keda" "kellesse"
                 "kellede" "keda" "kelledesse" ;
    in
    table {
      Sg => table {
        c   => kuka.s ! NCase Sg c
       } ;
      Pl => table {
        Nom => "ketkä" ;
        c   => kuka.s ! NCase Pl c
        }
      } ;
  mikaanPron : MorphoEst.Number => (MorphoEst.Case) => Str = \\n,c =>
    case <n,c> of {
        <Sg,Nom> => "mikään" ;
        <_,Part> => "mitään" ;
        <Sg,Gen> => "minkään" ;
        <Pl,Nom> => "mitkään" ;
        <Pl,Gen> => "mittenkään" ;
        <_,Ess>  => "minään" ;
        <_,Iness> => "missään" ;
        <_,Elat> => "mistään" ;
        <_,Adess> => "millään" ;
        <_,Ablat> => "miltään" ;
        _   => mikaInt ! n ! c + "kään"
       } ;

  kukaanPron : MorphoEst.Number => (MorphoEst.Case) => Str =
    table {
      Sg => table {
        Nom => "kukaan" ;
        Part => "ketään" ;
        Ess => "kenään" ;
        Iness => "kessään" ;
        Elat  => "kestään" ;
        Illat => "kehenkään" ;
        Adess => "kellään" ;
        Ablat => "keltään" ;
        c   => kukaInt ! Sg ! c + "kään"
       } ;
      Pl => table {
        Nom => "ketkään" ;
        Part => "keitään" ;
        Ess => "keinään" ;
        Iness => "keissään" ;
        Elat => "keistään" ;
        Adess => "keillään" ;
        Ablat => "keiltään" ;
        c   => kukaInt ! Pl ! c + "kään"
        }
      } ;


oper
  makeNP  : N -> MorphoEst.Number -> CatEst.NP ;
  makeNP noun num = {
    s = \\c => noun.s ! NCase num (npform2case num c) ;
    a = agrP3 num ;
    isPron = False ;
    lock_NP = <>
    } ;

lin
  not_Predet = {s = \\_,_ => "ei"} ;

  no_Quant = heavyQuant {
    s1 = \\n,c => "ei" ++ mikaanPron ! n ! c ;
    s2 = [] ; isNum,isPoss = False ; isDef = True ;
    } ;

  if_then_Conj = {s1 = "jos" ; s2 = "niin" ; n = Sg} ;
  nobody_NP = {
    s = \\c => "ei" ++ kukaanPron ! Sg ! npform2case Sg c ;
    a = agrP3 Sg ;
    isPron = False
    } ;

  nothing_NP = {
    s = \\c => "ei" ++ mikaanPron ! Sg ! npform2case Sg c ;
    a = agrP3 Sg ;
    isPron = False
    } ;

  at_least_AdN = ss "vähemalt" ;
  at_most_AdN = ss "kuni" ;

  as_CAdv = X.mkCAdv "yhtä" "kuin" ;

  except_Prep = postPrep partitive "lukuunottamatta" ;

  have_V2 = mkV2 (caseV adessive vOlla) ;

  -- Kaarel: TODO: not sure what this is...
  lin language_title_Utt = ss "suomi" ;

}

