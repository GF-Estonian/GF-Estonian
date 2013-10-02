-- TODO: include the full GrammarEst
-- The Slash* is currently excluded only for performance reasons.
concrete Lang1Est of Lang1 =
  GrammarEst - [Slash2V3,SlashV2A,Slash3V3,SlashV2VNP,SlashVV], ---- to speed up compilation
  DictEst
  ** {

flags startcat = Phr ; unlexer = text ; lexer = finnish ;

} ;
