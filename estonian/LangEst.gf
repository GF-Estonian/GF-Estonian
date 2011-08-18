--# -path=.:../abstract:../common:../prelude

concrete LangEst of Lang = 
--  GrammarEst - [SlashV2VNP,SlashVV], ---- to speed up compilation
  GrammarEst, 
  LexiconEst
  ** {

flags startcat = Phr ; unlexer = text ; lexer = finnish ;

} ;
