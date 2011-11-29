--# -path=.:../abstract:../common:../prelude

concrete ExtraEst of ExtraEstAbs = CatEst ** 
  open ResEst, MorphoEst, Coordination, Prelude, NounEst, StructuralEst, (R = ParamX) in {

  lin
    GenNP np = {
      s1,sp = \\_,_ => np.s ! NPCase Gen ;
      s2 = [] ;
      isNum  = False ;
      isPoss = False ;
      isDef  = True  --- "Jussin kolme autoa ovat" ; thus "...on" is missing
      } ;

    GenCN n1 n2 = {s = \\nf => n1.s ! NPCase Gen ++ n2.s ! nf} ;

  lincat
    VPI   = {s : Str} ;
    [VPI] = {s1,s2 : Str} ;
  lin
    BaseVPI = twoSS ;
    ConsVPI = consrSS comma ;

    MkVPI vp = {s = infVP (NPCase Nom) Pos (agrP3 Sg) vp Inf1} ;
    ConjVPI = conjunctDistrSS ;
    ComplVPIVV vv vpi = 
      insertObj (\\_,_,_ => vpi.s) (predV vv) ;

    AdvExistNP adv np = 
      mkClause (\_ -> adv.s) np.a (insertObj 
        (\\_,b,_ => np.s ! NPCase Nom) (predV (verbOlla ** {sc = NPCase Nom ; qp = True}))) ;

    RelExistNP prep rp np = {
      s = \\t,ant,bo,ag => 
      let 
        n = complNumAgr ag ;
        cl = mkClause 
          (\_ -> appCompl True Pos prep (rp2np n rp))
          np.a 
          (insertObj 
            (\\_,b,_ => np.s ! NPCase Nom) 
            (predV (verbOlla ** {sc = NPCase Nom ; qp = True}))) ;
      in 
      cl.s ! t ! ant ! bo ! SDecl ;
      c = NPCase Nom
      } ;

    AdvPredNP  adv v np =
      mkClause (\_ -> adv.s) np.a (insertObj 
        (\\_,b,_ => np.s ! NPCase Nom) (predV v)) ;

    ICompExistNP adv np = 
      let cl = mkClause (\_ -> adv.s ! np.a) np.a (insertObj 
        (\\_,b,_ => np.s ! NPCase Nom) (predV (verbOlla ** {sc = NPCase Nom ; qp = True}))) ;
      in  {
        s = \\t,a,p => cl.s ! t ! a ! p ! SDecl
      } ;

    IAdvPredNP iadv v np =
      let cl = mkClause (\_ -> iadv.s) np.a (insertObj 
                 (\\_,b,_ => np.s ! v.sc) (predV v)) ;
      in  {
        s = \\t,a,p => cl.s ! t ! a ! p ! SDecl
      } ;

--    i_implicPron = mkPronoun [] "minun" "minua" "minuna" "minuun" Sg P1 ;
    whatPart_IP = {
      s = table {
        NPCase Nom | NPAcc => "mitä" ;
        c => whatSg_IP.s ! c
        } ;
      n = Sg
    } ;

    PartCN cn = 
      let 
        acn = DetCN (DetQuant IndefArt NumSg) cn
      in {
        s = table {
          NPCase Nom | NPAcc => acn.s ! NPCase Part ;
          c => acn.s ! c
          } ; 
        a = acn.a ;
        isPron = False
        } ;

    vai_Conj = {s1 = [] ; s2 = "vai" ; n = Sg} ;

    -- Fin: pizza on herkullista
    -- TODO: remove or change this because in Estonian the copula adjective is in nominative
    CompPartAP ap = {
      s = \\agr => ap.s ! False ! NCase (complNumAgr agr) Part
      } ;

---- copied from VerbEst.CompAP, should be shared
    ICompAP ap = {
      s = \\agr => 
          let
            n = complNumAgr agr ;
            c = case n of {
              Sg => Nom ;  -- Fin (Nom): minä olen iso ; te olette iso
              Pl => Nom    -- Fin (Part): me olemme isoja ; te olette isoja
              }            --- definiteness of NP ?
          in "kui" ++ ap.s ! False ! (NCase n c)
      } ;

    IAdvAdv adv = {s = "kui" ++ adv.s} ;

    ProDrop p = {
      s = table {NPCase (Nom | Gen) => [] ; c => p.s ! c} ; 
          ---- drop Gen only works in adjectival position
      a = p.a
      } ;

    ProDropPoss p = {
      s1 = \\_,_ => [] ;
      sp = \\_,_ => p.s ! NPCase Gen ;
      s2 = BIND ++ possSuffix p.a ;
      isNum = False ;
      isPoss = True ;
      isDef = True  --- "minun kolme autoani ovat" ; thus "...on" is missing
      } ;

  lincat 
    ClPlus, ClPlusObj, ClPlusAdv = ClausePlus ;
    Part = {s : Bool => Str} ;

  lin 
    S_SVO part t p clp = 
      let 
         cl = clp.s ! t.t ! t.a ! p.p ;
         pa = part.s ! True ----
      in
      {s = t.s ++ p.s ++ cl.subj ++ pa ++ cl.fin ++ cl.inf ++ cl.compl ++ cl.adv ++ cl.ext} ; 
    S_OSV part t p clp = 
      let 
         cl = clp.s ! t.t ! t.a ! p.p ;
         pa = part.s ! True ----
      in
      {s = t.s ++ p.s ++ cl.compl ++ pa ++ cl.subj ++ cl.fin ++ cl.inf ++ cl.adv ++ cl.ext} ; 
    S_VSO part t p clp = 
      let 
         cl = clp.s ! t.t ! t.a ! p.p ;
         pa = part.s ! cl.qp
      in
      {s = t.s ++ p.s ++ cl.fin ++ pa ++ cl.subj ++ cl.inf ++ cl.compl ++ cl.adv ++ cl.ext} ; 
    S_ASV part t p clp = 
      let 
         cl = clp.s ! t.t ! t.a ! p.p ;
         pa = part.s ! cl.qp
      in
      {s = t.s ++ p.s ++ cl.adv ++ pa ++ cl.subj ++ cl.fin ++ cl.inf ++ cl.compl ++ cl.ext} ; 

    PredClPlus np vp = mkClausePlus (subjForm np vp.sc) np.a vp ;
    PredClPlusFocSubj np vp = insertKinClausePlus 0 (mkClausePlus (subjForm np vp.sc) np.a vp) ;
    PredClPlusFocVerb np vp = insertKinClausePlus 1 (mkClausePlus (subjForm np vp.sc) np.a vp) ;
    PredClPlusObj  np vps obj = 
      insertObjClausePlus 0 False (\\b => appCompl True b vps.c2 obj) (mkClausePlus (subjForm np vps.sc) np.a vps) ;
    PredClPlusFocObj  np vps obj = 
      insertObjClausePlus 0 True (\\b => appCompl True b vps.c2 obj) (mkClausePlus (subjForm np vps.sc) np.a vps) ;
    PredClPlusAdv  np vp  adv = 
      insertObjClausePlus 1 False (\\_ => adv.s) (mkClausePlus (subjForm np vp.sc) np.a vp) ;
    PredClPlusFocAdv  np vp  adv = 
      insertObjClausePlus 1 True (\\_ => adv.s) (mkClausePlus (subjForm np vp.sc) np.a vp) ;

    ClPlusWithObj c = c ;
    ClPlusWithAdv c = c ;

  noPart     = {s = \\_ => []} ;
  han_Part   = mkPart "han" "hän" ;
  pa_Part    = mkPart "pa" "pä" ;
  pas_Part   = mkPart "pas" "päs" ;
  ko_Part    = mkPart "ko" "kö" ;
  kos_Part   = mkPart "kos" "kös" ;
  kohan_Part = mkPart "kohan" "köhän" ;
  pahan_Part = mkPart "pahan" "pähän" ;

} 
