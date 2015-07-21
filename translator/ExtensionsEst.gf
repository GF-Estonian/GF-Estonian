--# -path=.:../abstract

concrete ExtensionsEst of Extensions = 
  CatEst ** open MorphoEst, ResEst, ParadigmsEst, SyntaxEst, (E = ExtraEst), (G = GrammarEst), Prelude in {

flags literal=Symb ; coding = utf8 ;

lincat
  VPI = E.VPI ;
  ListVPI = E.ListVPI ;
  VPS = E.VPS ;
  ListVPS = E.ListVPS ;
  
lin
  MkVPI = E.MkVPI ;
  ConjVPI = E.ConjVPI ;
  ComplVPIVV = E.ComplVPIVV ;

  MkVPS = E.MkVPS ;
  ConjVPS = E.ConjVPS ;
  PredVPS = E.PredVPS ;

  BaseVPI = E.BaseVPI ;
  ConsVPI = E.ConsVPI ;
  BaseVPS = E.BaseVPS ;
  ConsVPS = E.ConsVPS ;

----  GenNP = E.GenNP ;
----  GenIP = E.GenIP ;
----  GenRP = E.GenRP ;

  PassVPSlash = E.PassVPSlash ;
  PassAgentVPSlash = E.PassAgentVPSlash ;

----  EmptyRelSlash = E.EmptyRelSlash ;


lin
{--
    ComplVV v ant p vp = 
      let 
        vpi = infVP v.isAux vp 
      in
       insertExtrapos vpi.p4 (
        insertInfExt vpi.p3 (
          insertInf vpi.p2 (
            insertObj vpi.p1 (
              predVGen v.isAux v)))) ;

    PastPartRS ant pol sl = {   -- guessed by KA, some fields in sl are ignored!!
      s = \\gn => let agr = agrgP3 Masc (numGenNum gn)
                  in sl.s.s ! VPastPart APred ++ 
                     (sl.nn ! agr).p1 ++ (sl.nn ! agr).p2 ++ sl.a2;
      c = Nom
      } ;

    PresPartRS ant pol vp = {   -- guessed by KA!!
      s = \\gn => let agr = agrgP3 Masc (numGenNum gn)
                  in vp.s.s ! VPresPart APred ++ 
                     (vp.nn ! agr).p1 ++ (vp.nn ! agr).p2;
      c = Nom
      } ;
--}

    PredVPosv = G.PredVP;
    PredVPovs = G.PredVP;

lin
  that_RP = which_RP ;

  UttAdV adv = adv;

  DirectComplVS t np vs utt = 
    mkS (lin Adv (optCommaSS utt)) (mkS t positivePol (mkCl np (lin V vs))) ;

  DirectComplVQ t np vs q = 
    mkS (lin Adv (optCommaSS (mkUtt q))) (mkS t positivePol (mkCl np (lin V vs))) ;

}
