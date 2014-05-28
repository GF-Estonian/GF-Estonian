<h1 style="position: relative; line-height: 85%">
<div style="position: absolute; left: 50%; margin-left: -400px; width: 800px; bottom: 50%; font-size: 80%; font-weight: bold">Computational Estonian Grammar in Grammatical Framework</div>
<div style="position: absolute; left: 50%; margin-left: -400px; width: 800px; bottom: 35%; font-size: 45%"><b>Inari Listenmaa</b>, Kaarel Kaljurand</div>
<div style="position: absolute; left: 50%; margin-left: -400px; width: 800px; bottom: 25%; font-size: 45%; font-style: italic"></div>
<div style="position: absolute; left: 50%; margin-left: -300px; width: 600px; bottom: 16%; font-size: 40%">SaLTMiL 2014, Reykjavík, Iceland</div>
<div style="position: absolute; left: 50%; margin-left: -300px; width: 600px; bottom: 10%; font-size: 40%">2014-05-27</div>
</h1>


---
# Grammatical Framework (GF)

  - Programming language for multilingual grammar applications
  - Bidirectional mapping: **abstract syntax** ↔ **concrete syntaxes**
  - Translation = parse to abstract tree + linearise into concrete language
  
---
# Example

    !haskell
    -- a "Hello World" grammar
    abstract Hello = {

      flags startcat = Greeting ;

      cat Greeting ; Recipient ;

      fun
        Hello : Recipient -> Greeting ;
        World, Mum, Friends : Recipient ;
    }   

---
# English concrete syntax

    !haskell
    concrete HelloEng of Hello = {

      lincat Greeting, Recipient = {s : Str} ;

      lin
        Hello recip = {s = "hello" ++ recip.s} ;
        World       = {s = "world"} ;
        Mum         = {s = "mum"} ;
        Friends     = {s = "friends"} ;
    }

---
# Icelandic concrete syntax


    !haskell
    concrete HelloIce of Hello = {

      lincat 
        Greeting  = {s : Str} ;
        Recipient = {s : Str ; n : Number ; g : Gender} ;

      lin
        Hello rec = {s = case <rec.g,rec.n> of
                          <Sg,Masc> => "sæll"  ++ rec.s ;
                          <Sg,_>    => "sæl"   ++ rec.s ;
                          <Pl,Masc> => "sælir" ++ rec.s ;
                          <Pl,_>    => "sælar" ++ rec.s } ;
        World     = {s = "heimur" ; g = Masc ; n = Sg} ; 
        Mum       = {s = "mamma"  ; g = Fem  ; n = Sg} ;
        Friends   = {s = "vinir"  ; g = Masc ; n = Pl} ;

      param
        Gender = Fem | Masc | Neutr ;
        Number = Sg | Pl ;
}

<!--
More linguisticly motivated example: greeting depends on the gender/number of the recipient
-->


---
# Resource Grammar Library

  - Resource grammar: implementation of morphology and syntax
  - Shared abstract syntax of 300+ rules + language-specific extra modules
  - Morphology: language-independent constructor functions from 1–n base forms
    - smart paradigms!
  - Common API for shared syntax features

    	   mkCl (mkNP that_Det house_N) red_A

	       → “that house is red”
	       → “aquella casa és roja”
	       → “see maja on punane”

---
# Estonian

  - Spoken in Estonia by ~1 million people
  - (Balto-)Finnic subgroup of Uralic languages
  - Related languages: Finnish (~5M speakers), Võro (75k speakers), Karelian, Votic, Veps, ...

---
# Estonian LT resources

  - Morphology: spellers and thesauri in mainstream text processing suites
    - FOSS morphology! [github.com/jjpp/plamk](https://github.com/jjpp/plamk)
  - Syntax: Constraint grammar; dependency parsing
  - Lexicon: WordNet; verb frame lexicons
  - Speech technology: My android phone recognises if I speak Estonian with Finnish accent
  - MT: Google translate; very preliminary fin-est in Apertium :-D
  - [cl.ut.ee/ressursid/](http://www.cl.ut.ee/ressursid/)


---
# Morphology

---
# Nouns

- 14 cases
- 2 numbers
- Inflectional suffixes added to stem, also stem changes
- Implementation based on Kaalep 2012, _Eesti käänamissüsteemi seaduspärasused_ (HJK EKS)
- max. 6 forms needed, other 8 based on genitive

<!-- 
  - rules in HJK EKS depend on singular nominative, its stress, quantity, derivation from a verb, foreignness

Example infl table of a noun
  Sg Nom => naine
  Sg Gen => naise
  Sg Part => naist
  Sg Illat => naisesse
  Sg Iness => naises
  Sg Elat => naisest
  Sg Allat => naisele
  Sg Adess => naisel
  Sg Ablat => naiselt
  Sg Transl => naiseks
  Sg Ess => naisena
  Sg Termin => naiseni
  Sg Abess => naiseta
  Sg Comit => naisega
  Pl Nom => naised
  Pl Gen => naiste
  Pl Part => naisi
  Pl Illat => naistesse
  Pl Iness => naistes
  Pl Elat => naistest
  Pl Allat => naistele
  Pl Adess => naistel
  Pl Ablat => naistelt
  Pl Transl => naisteks
  Pl Ess => naistena
  Pl Termin => naisteni
  Pl Abess => naisteta
  Pl Comit => naistega
-->


---
# Nouns: GF representation

	!haskell
	param
      Number = Sg | Pl ;
      Case = Nominative | Genitive | Partitive
           | Illative | Inessive | Elative 
           | Allative | Adessive | Ablative
           | Translative | Essive 
           | Terminative | Abessive | Comitative ;

      NForm = NCase Number Case ;

	oper
      Noun : Type = {s : NForm => Str} ;

---
# Nouns

13 templates for creating 6 forms from 1 (sg nom)

	!haskell
	-- if ends with 'i' ('arvuti') then last form is 'arvut' + 'e' + 'id'
	-- There are ~50 such words in the WordNet.
	hjk_type_IVa_aasta x =
		let
		   x_e : Str = case x of {
		   	            _ + "i" => (init x) + "e" ;
			            _       => x }
		in
		nForms6 x x (x+"t") (x+"sse") (x+"te") (x_e+"id") ;


<!--
Mapping singular nominative to the templates

	/2 II V/               -> type 3
	/2 I V/, foreign       -> type 3
	/2 III V/              -> type 4a
	/3 CV[lmnr]/           -> type 6 seminar
	/e/, derived from verb -> type 7
	...
-->

---
# Smart paradigms

Matching words based on endings and stress patterns

	!haskell
	case <(syl_type x), x, i> of {
			<_, _ + #vv + ("lik"|"nik"|"stik"), _>
				=> hjk_type_IVb_audit x "u" ;

			<S3, _ + #v + #v + #c, i>
				=> hjk_type_VI_link2 x i ;

			<(S1|S3), _ + #v + #c + #c, i>
				=> hjk_type_VI_link2 x i ;

			<(S21|S22), _ + ("nu"|"tu"), _>
				=> hjk_type_IVa_aasta x ;

2-arg smart paradigm: genitive as additional argument

	mkN "lakk"        => lakk, laki, lakki, lakki, lakkide, lakkisid
	mkN "lakk" "laka" => lakk, laka, lakka, lakka, lakkade, lakkasid
	

---
# Adjectives

  - Inflect like nouns in case and number
  - Comparative derived from genitive
  - Separate superlative only for some adjectives; can be expressed also by _kõige_ ('most') + ``Comparative``
  - Adverbial form derived from ablative or with suffix -sti



---
# Adjectives

Most adjectives agree with nouns in case and number:

	suure+s    linna+s
	big.Sg+INE town.Sg+INE

---
# Adjectives

Most adjectives agree with nouns in case and number:

	suure+s    linna+s
	big.Sg+INE town.Sg+INE

**Adjectives derived from participles do not agree as modifiers:**

	väsinud      mehe+le
	tired.Sg.NOM man.Sg+ALL


---
# Adjectives

Most adjectives agree with nouns in case and number:

	suure+s    linna+s
	big.Sg+INE town.Sg+INE

Adjectives derived from participles do not agree as modifiers:

	väsinud      mehe+le
	tired.Sg.NOM man.Sg+ALL

**but inflect as predicatives:**

	mees muutus väsinu+ks      
	man  became tired.Sg.TRANSL


---
# Adjectives

Most adjectives agree with nouns in case and number:

	suure+s    linna+s
	big.Sg+INE town.Sg+INE

Adjectives derived from participles do not agree as modifiers:

	väsinud      mehe+le
	tired.Sg.NOM man.Sg+ALL

but inflect as predicatives:

	mees muutus väsinu+ks      
	man  became tired.Sg.TRANSL

**Invariable adjectives do not agree, inflect nor allow comparative or superlative:**

	linn sai    valmis
	town became ready.Sg.NOM

---
# Adjectives


	!haskell
	param
	  AForm  = AN NForm | AAdv ;
	  Degree = Positive | Comparative | Superlative ;
	  Infl   = Regular | Participle | Invariable ;
	oper
	  Adjective : Type = {s : Degree => AForm => Str ; infl : Infl} ;


---
# Verbs

  - Inflection in voice, mood, tense, person, number 
  - Non-finite forms and participles that inflect like nouns
  - 40 forms, incl. 11 non-finite

  - Full conjugation tables from 8 forms
    - for comparison: Finnish worst case 12 forms
  - Choice of forms based on Erelt et al., 2009 _Eesti keele käsiraamat_
  - Smart paradigms for 1–4 arguments

---
# Verbs
	!haskell
	oper
	  Verb : Type = {
	    s : VForm => Str ;
	    p : Str  -- particle verbs
	  } ; 

	param 
	  VForm = 
	   Presn Number Person | Impf Number Person 
	 | Condit Number Person | Quotative Voice
	 | Imper Number | ImperP3 | ImperP1Pl | ImpNegPl
	 | PassPresn Bool | PassImpf Bool --Positive or negative
	 | PresPart Voice | PastPart Voice | Inf InfForm ;

	 Person  = P1 | P2 | P3 ;
	 Voice   = Active | Passive ;

	 InfForm = 
	   InfDa | InfDes | InfMa | InfMas | InfMast | InfMata | InfMaks ;


  
---
# Smart paradigms

  - 15 templates for creating 8 forms from 1 forms
  - 1–4-argument smart paradigms

<pre>    

> cc mkV "lugema" "lugeda" "loeb"
{s = table
       ResEst.VForm
       ["lugeda"; "lugedes"; "lugema"; "lugemas"; "lugemast"; "lugemata";
        "lugemaks"; "loen"; "loed"; "loeb"; "loeme"; "loete"; "loevad";
        "lugesin"; "lugesid"; "luges"; "lugesime"; "lugesite"; "lugesid";
        "loeksin"; "loeksid"; "loeks"; "loeksime"; "loeksite"; "loeksid";
        "loe"; "lugege"; "lugegu"; "lugegem"; "lugege"; "loeta";
        "loetakse"; "loetud"; "loeti"; "lugevat"; "loetavat"; "lugev";
        "loetav"; "lugenud"; "loetud"];
 p = []; sc = ResEst.NPCase ResEst.Nom; lock_V = <>}
</pre>


---
# Testing morphology

  - Percentage of words covered by the smart paradigms
  - using Filosoft's morph. synthesizer as the gold standard
  - test vocabulary e.g. from the Estonian WordNet (44k words in 29k synsets)


| Testset    | Constructor | 1-arg | 2-arg | 3-arg | 4-arg |
| ---------- |-------------|-------|-------|-------|:-----:|
| nouns      | ``mkN``     | 91.1  | 95.4  | 97.1  | 98.2  |
| adjectives | ``mkN``     | 90.0  | 93.6  | 95.2  | 96.9  |
| verbs      | ``mkV``     | 90.5  | 96.6  | 98.3  | 99.7  |

---
# Lexicon

---
# Lexicon

350-word basic lexicon for all RG languages:

	!haskell
	 fun_AV = mkAV (mkA (mkN "lõbus" "lõbusa" "lõbusat")) ;
	 garden_N = mkN "aed" "aia" "aeda";
	 green_A = mkA "roheline" ;
	 hate_V2 = mkV2 (mkV "vihkama" "vihata") partitive ;
	 know_VS = mkVS (mkV "teadma" "teada" "teab") ; --know that S
	 know_VQ = mkVQ (mkV "teadma" "teada" "teab") ; --know if QS
	 know_V2 = mkV2 (mkV "tundma") ;                --know someone

---
# Lexicon

80k-word monolingual lexicon:

	!haskell
	vaas_N = mkN "vaas" "vaasi" "vaasi" "vaasisse" "vaaside" "vaase" ;
	vaataja_N = mkN "vaataja" "vaataja" "vaatajat" "vaatajasse" "vaatajate" "vaatajaid" ;
	vaatama_V2 = mkV2 (mkV "vaatama" "vaadata" "vaatab" "vaadatakse" "vaadake" "vaatas" "vaadanud" "vaadatud") ;
	vaatamine_N = mkN "vaatamine" "vaatamise" "vaatamist" "vaatamisesse" "vaatamiste" "vaatamisi" ;

Sources:

  - EstWN
  - the verbs of the EstCG lexicon <!-- which provides information on the verb complement and adjunct cases--> 
  - database of multi-word verbs 

Morfessor 2.0 used for compound word splitting of nouns

Filosoft’s morphology tools used to generate the base forms for our constructors

---
# Lexicon

  - 65k-word multilingual lexicon
  - Currently implemented by 11 languages
  - TODO for Estonian
    - Then possible to do MT!

---
# Syntax
 
---
# Syntax

  - Unmarked word order SVO + tendency for V2
  - Other word orders grammatical but semantically marked
  - Adjectives¹ agree with nouns²
  - Verbs require cases from complements
    - object case indicates aspect: accusative vs. partitive
    - many verbs with non-inflecting component


¹) Except those that don't <br/>
²) Except in 4 cases


---
# Syntax

  - Unmarked word order SVO + tendency for V2
  - Other word orders grammatical but semantically marked
  - Adjectives¹ agree with nouns²
  - Verbs require cases from complements
    - object case indicates aspect: accusative vs. partitive
    - many verbs with non-inflecting component

<pre>
    mina saan sinust aru
    mina ei saa sinust aru
    mina tahan sinust aru saada
</pre>

¹) Except those that don't <br/>
²) Except in 4 cases

<!--  - Started with a copy of the Finnish RG
  - several changes
    - "-ko" particle -> "kas"
    - possessive endings -> "minu"/"tema"/"oma"
      - reflexive possessive _oma_ as a separate construction in ExtraEst
    - Word order: V2
    - Multi-word verbs
    - also lacking from Finnish (Fin _ylläpitää ~ pidän yllä_; Est _aru saama ~ saan aru_)

---
# Interesting phenomena

Verb complement stuff
Word order + interaction with multi-word verbs
-->


---
# Comparison to Finnish

  - Metrics: Shared categories and functions
  - Morphological complexity and predictability
  - Syntactic phenomena

---
# Comparison to Finnish

  - **Metrics: Shared categories and functions**
    - 23/48 of categories are different
    - Finnish vowel harmony, clitics
    - Estonian MWVs, complex inflection in adjectives
  - Morphological complexity and predictability
  - Syntactic phenomena

---
# Comparison to Finnish

  - Metrics: Shared categories and functions
  - **Morphological complexity and predictability**
    - Number of "non-smart" paradigms in MorphoEst and MorphoFin
    - Percentage of correct results for 1–4 arg smart paradigms
    - cf. Aarne Ranta 2008, _How predictable is Finnish morphology? An experiment on lexicon construction._

  - Syntactic phenomena

---
# Comparison to Finnish

  - Metrics: Shared categories and functions
  - Morphological complexity and predictability
  - **Syntactic phenomena** 
    - Word order
    - Complement cases
    - Specific constructions

<!--
e.g. you can modify a noun with a noun in other case; wooden table "wood.ELA table" and the noun doesn't inflect like the rest
or reflexive pronoun
-->

---
# Expert opinion

John McWhorter in _Linguistic simplicity and complexity_

> Importantly, I have by no means chosen the most baroque comparison possible. Partitive marking in Finnish's close sister Estonian is so much more elaborate in terms of complex interaction with its notoriously complex consonant gradations plus rampant irregularity that its very learnability seems almost questionable.

---
# Expert opinion

John McWhorter in _Linguistic simplicity and complexity_

> Importantly, I have by no means chosen the most baroque comparison possible. Partitive marking in Finnish's close sister Estonian is so much more elaborate in terms of complex interaction with its notoriously complex consonant gradations plus rampant irregularity that its very learnability seems almost questionable.

GF paradigms indicate otherwise: 

  - 1-arg paradigm 80 % correct in Finnish, 90 % in Estonian
  - Worst-case constructor needs 10 forms in Finnish, 6 in Estonian
  - Dependent on test set and implementation!

---
# Evaluation

---
# Evaluation

  - Morphology
    - Evaluation of smart paradigms against Filosoft gold standard

  - Syntax:
    - Linearise and verify GF documentation sentences
    - Add Estonian in two medium-scale GF grammars
    - TODO: large-scale evaluation in parsing/translation

---
# Resources used

  - Noun morphology
    - Heiki-Jaan Kaalep. Eesti käänamissüsteemi seaduspärasused <http://kjk.eki.ee/ee/issues/2012/6/156>
  - Verb morphology
    - Eesti õigekeelsussõnaraamat (2006) classification system _tüüpsõnad_ <http://www.eki.ee/dict/qs/tyypsonad.html>
    - Eesti keele käsiraamat (2009) for internal paradigm building (``VForms -> Verb``) <http://www.eki.ee/books/ekk09/index.php?p=3|p1=5|id=227>
    - Estonian WordNet <http://www.cl.ut.ee/ressursid/teksaurus/>
  
---
# Future work

  - Large-scale testing
  - Sharing of code with Finnish: parametrised module
    - Possible to implement other Finnic languages with less effort!
  - DictionaryEst: connect monolingual lexicon to multilingual
     - WordNet ILIs?

---
# Täname!
