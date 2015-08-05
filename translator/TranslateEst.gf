--# -path=.:../chunk:alltenses:../estonian

concrete TranslateEst of Translate = 
  TenseX,
  NounEst - [PPartNP],
  AdjectiveEst,
  NumeralEst,
  SymbolEst [
    PN, Symb, String, CN, Card, NP, MkSymb, SymbPN, CNNumNP
    ],
  ConjunctionEst,
  VerbEst -  [
    UseCopula,  
    PassV2
    ],
  AdverbEst,
  PhraseEst,
  SentenceEst,
  QuestionEst,
  RelativeEst,
  IdiomEst,
  ConstructionEst,
  DocumentationEst,

  ChunkEst,
  ExtensionsEst [
    ListVPS,BaseVPS,ConsVPS,ConjVPS,ListVPI,BaseVPI,ConsVPI,ConjVPI,
    CompoundN,AdAdV,UttAdV,ApposNP,MkVPI, MkVPS, PredVPS, PassVPSlash, PassAgentVPSlash, CompoundAP
    , PastPartAP, PastPartAgentAP, PresPartAP, GerundNP, GerundAdv
    , WithoutVP, InOrderToVP, ByVP
    ],

  DictionaryEst ** 
open MorphoEst, ResEst, ParadigmsEst, SyntaxEst, (E = ExtraEst), Prelude in {

flags
  literal=Symb ;

}
