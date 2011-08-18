abstract ExtraFinAbs = Extra [
  GenNP,VPI,ListVPI,BaseVPI,ConsVPI,MkVPI,ComplVPIVV,ConjVPI,
  VV,VP,Conj,NP,Quant,IAdv,IComp,ICompAP,IAdvAdv,Adv,AP, Pron, ProDrop] ** {

  fun
    AdvExistNP : Adv -> NP -> Cl ;        -- kuvassa olemme me
    AdvPredNP  : Adv -> V  -> NP -> Cl ;  -- kuvassa hymyilee Veikko

    RelExistNP : Prep -> RP -> NP -> RCl ; -- jossa on jazzia

--    i_implicPron : Pron ;                 -- (min�), minut, ...
    whatPart_IP : IP ;

    PartCN : CN -> NP ;                   -- olutta

    vai_Conj : Conj ;                     -- min� vai sin�? ("or" in question)

    CompPartAP : AP -> Comp ;             -- kahvi on valmista

    ProDropPoss : Pron -> Quant ;         -- vaimoni

  cat
    ClPlus ;      -- clause with more variation
    ClPlusObj ;   -- which has a focusable object
    ClPlusAdv ;   -- which has a focusable adverb
    Part ;        -- discourse particle

  fun
    S_SVO  : Part -> Temp -> Pol -> ClPlus     -> S ;  -- mep�s juomme maitoa nyt
    S_OSV  : Part -> Temp -> Pol -> ClPlusObj  -> S ;  -- maitoapas me juomme nyt
    S_VSO  : Part -> Temp -> Pol -> ClPlus     -> S ;  -- juommepas me maitoa nyt
    S_ASV  : Part -> Temp -> Pol -> ClPlusAdv  -> S ;  -- nytp�s me juomme maitoa

--    S_SOV  : Part -> Temp -> Pol -> ClPlus  -> S ;  -- mep�s maitoa juomme
--    S_OVS  : Part -> Temp -> Pol -> ClPlus  -> S ;  -- maitoapas juomme me
--    S_VOS  : Part -> Temp -> Pol -> ClPlus  -> S ;  -- juommepas maitoa me


    PredClPlus        : NP -> VP            -> ClPlus ;      -- me nukumme
    PredClPlusFocSubj : NP -> VP            -> ClPlus ;      -- mekin nukumme
    PredClPlusFocVerb : NP -> VP            -> ClPlus ;      -- me nukummekin
    PredClPlusObj     : NP -> VPSlash -> NP -> ClPlusObj ;   -- maitoa me juomme
    PredClPlusFocObj  : NP -> VPSlash -> NP -> ClPlusObj ;   -- maitoakin me juomme
    PredClPlusAdv     : NP -> VP -> Adv     -> ClPlusAdv ;   -- nyt me nukumme
    PredClPlusFocAdv  : NP -> VP -> Adv     -> ClPlusAdv ;   -- nytkin me nukumme

    ClPlusWithObj : ClPlusObj -> ClPlus ;   -- to make non-fronted obj focusable
    ClPlusWithAdv : ClPlusAdv -> ClPlus ;   -- to make non-fronted adv focusable

    noPart, han_Part, pa_Part, pas_Part, ko_Part, kos_Part, 
      kohan_Part, pahan_Part : Part ; 

}
