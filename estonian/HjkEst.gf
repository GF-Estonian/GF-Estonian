resource HjkEst = open ResEst, Prelude, Predef in {

  flags
	coding = utf8 ;

  -- TODO: change the name of this file and the names of the opers in this file

  param
	-- S21, S22, S23 apply only to words that end with a vowel
	SylType = S1 | S2 | S21 | S22 | S23 | S3 ;

  oper

	NFS = {s : NForm => Str} ;

	foreign : pattern Str = #("z" | "ž" | "š") ;
	-- Foreign vowel endings
	-- TODO: very experimental
	foreign_v : pattern Str = #("ko" | "po" | "to" | "fo" | "ka" | "pa" | "ta" | "fa" | "ku" | "pu" | "tu" | "fu" | "ri") ;
	v : pattern Str = #("a" | "e" | "i" | "o" | "u" | "õ" | "ä" | "ö" | "ü") ;
	vv : pattern Str = #("aa" | "ee" | "ii" | "oo" | "uu" | "õõ" | "ää" | "öö" | "üü") ;
	c : pattern Str = #("m" | "n" | "p" | "b" | "t" | "d" | "k" | "g" | "f" | "v" | "s" | "h" | "l" | "j" | "r" | "z" | "ž" | "š") ;
	lmnr : pattern Str = #("l" | "m" | "n" | "r") ;
	kpt : pattern Str = #("k" | "p" | "t" | "f" | "š") ;
	gbd : pattern Str = #("g" | "b" | "d") ;

	hjk_type_I_koi : Str -> NFS ;

	hjk_type_I_koi x =
		nForms6 x x (x+"d") (x+"sse") (x+"de") (x+"sid") ;


	hjk_type_II_ema : Str -> NFS ;

	hjk_type_II_ema x =
		nForms6 x x x (x+"sse") (x+"de") (x+"sid") ;


	hjk_type_III_ratsu : Str -> NFS ;

	hjk_type_III_ratsu x =
		nForms6 x x (x+"t") (x+"sse") (x+"de") (x+"sid") ;


	-- TODO: if 'arvuti' is of this type then last form is 'arvut' + 'eid' (50 errors)
	hjk_type_IVa_aasta : Str -> NFS ;

	hjk_type_IVa_aasta x =
		nForms6 x x (x+"t") (x+"sse") (x+"te") (x+"id") ;


	hjk_type_IVb_audit : Str -> Str -> NFS ;

	hjk_type_IVb_audit x v_g =
		let
			v_pl = case v_g of { "i" => "e" ; _ => v_g }
		in
		nForms6 x (x+v_g) (x+v_g+"t") (x+v_g+"sse") (x+v_g+"te") (x+v_pl+"id") ;

	-- TODO: clean this up
	hjk_type_IVb_audit1 : Str -> Str -> NFS ;
	hjk_type_IVb_audit1 x y =
		nForms6 x (y + "i") (y+"it") (y+"isse") (y+"ite") (y+"eid") ;


	hjk_type_IVb_maakas : Str -> NFS ;

	hjk_type_IVb_maakas x =
		let
			gen = init x
		in
		nForms6 x gen (gen+"t") (gen+"sse") (gen+"te") (gen+"id") ;


	-- TODO: variant: vastusesse | vastusse
	hjk_type_Va_otsene : Str -> NFS ;

	hjk_type_Va_otsene x =
		let
			f : Str = case x of { y + "ne" => y + "s" ; _ => x }
		in
		nForms6 x (f+"e") (f+"t") (f+"esse") (f+"te") (f+"eid") ;


	-- TODO: variant: olulisesse | olulisse
	hjk_type_Vb_oluline : Str -> NFS ;

	hjk_type_Vb_oluline x =
		let
			f : Str = case x of { y + "ne" => y + "s" ; _ => x }
		in
		nForms6 x (f+"e") (f+"t") (f+"esse") (f+"te") (f+"i") ;


	hjk_type_VI_link : Str -> NFS ;

	hjk_type_VI_link x =
		let
			x_n : Str = weaker_noun x
		in
		nForms6 x (x_n+"i") (x+"i") (x+"i") (x+"ide") (x+"e") ;


	hjk_type_VI_imelik : Str -> NFS ;

	hjk_type_VI_imelik x =
		let
			x_t : Str = stronger x
		in
		nForms6 x (x+"u") (x_t+"u") (x_t+"u") (x+"e") (x_t+"e") ;


	hjk_type_VI_meeskond : Str -> NFS ;

	hjk_type_VI_meeskond x =
		let
			x_n : Str = weaker_noun x
		in
		nForms6 x (x_n+"a") (x+"a") (x+"a") (x+"ade") (x+"i") ;


	hjk_type_VI_seminar : Str -> NFS ;

	hjk_type_VI_seminar x =
		nForms6 x (x+"i") (x+"i") (x+"i") (x+"ide") (x+"e") ;


	hjk_type_VII_touge : Str -> NFS ;

	hjk_type_VII_touge x =
		let
			x_t : Str = stronger x
		in
		nForms6 x x_t (x+"t") (x_t+"sse") (x+"te") (x_t+"id") ;


	-- Use this only to weaken the verbs
	weaker : Str -> Str ;
	weaker link =
		let
			li = Predef.tk 2 link ;
			nk = Predef.dp 2 link
		in
		case nk of {
			"kk" => li + "k" ;
			"pp" => li + "p" ;
			"tt" => li + "t" ;
			"ss" => li + "s" ;
			("üt"|"üs") => li + "ö" ; --süsi,söe ; ütlema,öelda
			V@(#v) + "k" => li + V + "g" ;
			V@(#v) + "p" => li + V + "b" ;
			V@(#v) + "t" => li + V + "d" ;
			V@(#v) + "d" => li + V ; --hoidma,hoiab
			N@(#lmnr) + "k" => li + N + "g" ;
			N@(#lmnr) + "p" => li + N + "b" ;
			N@(#lmnr) + "t" => li + N + "d" ;
			N@(#lmnr) + "d" => li + N + N ;
			N@("l"|"r") + "g" => li + N ; --algama,alata
			"sk" => li + "s" ;
			"h" + #kpt => li + "h" ;
			"nd" => li + "nn" ;
			"ad" => li + "aj" ;
			"mb" => li + "mm" ;
			("ug"|"ub") => li + "o" ;
			_ => link
	} ;


	-- Only the very stable weakening that happens to nouns
	weaker_noun : Str -> Str ;
	weaker_noun link =
		case link of {
			li + "kk" => li + "k" ;
			li + "pp" => li + "p" ;
			li + "tt" => li + "t" ;
			li + "ff" => li + "f" ;
			li + V@(#v) + "k" => li + V + "g" ;
			li + V@(#v) + "p" => li + V + "b" ;
			li + V@(#v) + "t" => li + V + "d" ;
			li + N@(#lmnr) + "k" => li + N + "g" ;
			li + N@(#lmnr) + "p" => li + N + "b" ;
			li + N@(#lmnr) + "t" => li + N + "d" ;
			li + "h" + #kpt => li + "h" ;
			li + "kond" => li + "konn" ;
			_ => link
	} ;


	-- TODO: implement fully
	stronger : Str -> Str ;
	stronger x =
		let
			beginning = tk 2 x ;
			ending = dp 2 x
		in
		beginning + case ending of {
			y + k@("k"|"p"|"t"|"s") + e => y + k + k + e ;
			y + "g" + e => y + "k" + e ;
			y + "d" + e => y + "t" + e ;
			y + "b" + e => y + "p" + e ;
			_ => ending
		} ;


	hjk_type : Str -> NFS ;

	hjk_type x =
		let
			sc = syl_type x
		in
		case <sc,x> of {
			<_, _ + ("kond")> => hjk_type_VI_meeskond x ;
			<S2, _ + ("a"|"e"|"i") + ("ng"|"k")> => hjk_type_IVb_audit x "u" ; -- but not 'konjak'
			-- TODO: this is more relaxed than in HJKEKS: _ + ("lik"|"nik"|"stik")
			<_, _ + #c + ("ik")> => hjk_type_VI_imelik x ;
			<_, _ + ("ngas"|"kas"|"jas"|"nud"|"tud")> => hjk_type_IVb_maakas x ;
			<_, _ + "ia"> => hjk_type_IVa_aasta x ; -- TODO: not in HJKEKS
			<S1, _ + #v + #v> => hjk_type_I_koi x ; -- this should not match 'anatoomia'
			<S1, _ + #vv + #c> => hjk_type_VI_link x ; -- 'statiiv' (not like 'karjuv')
			<S3, _ + #c + #v + #lmnr> => hjk_type_VI_seminar x ;
			-- next 3: not S2
			<S1, _ + #v + #v + #c> => hjk_type_VI_link x ;
			<S1, _ + #v + #c + #c> => hjk_type_VI_link x ;
			<S1, _ + #v + #c + #c + #c> => hjk_type_VI_link x ;
			<_, _ + ("us"|"is")> => hjk_type_Vb_oluline x ;
			-- next 3: not S2
			<S3, _ + #v + #v + #c> => hjk_type_VI_link x ;
			<S3, _ + #v + #c + #c> => hjk_type_VI_link x ;
			<S3, _ + #v + #c + #c + #c> => hjk_type_VI_link x ;
			<_, _ + "nna"> => hjk_type_III_ratsu x ;
			<_, _ + ("nu"|"tu")> => hjk_type_IVa_aasta x ;
			<S2, _ + #foreign + _ + "in"> => hjk_type_IVb_audit x "i" ; -- TODO: better foreign detection
			-- 'absurd' vs 'ebard'
			<S2, _ + #v + #lmnr + "d"> => hjk_type_IVb_audit x "i" ; -- TODO: this is not in HJKEKS
			-- sometimes 'a' (laurits) TODO: this is not in HJKEKS
			<S2, _ + #v + #kpt + "s"> => hjk_type_IVb_audit x "i" ;
			<S2, _ + ("em"|"im")> => hjk_type_IVb_audit x "a" ; -- comparative and superlative
			-- TODO: next 3 rules: last syllable must be long
			-- portfell, TODO: not 'karask'
			<S2, _ + #v + #c + #c> => hjk_type_VI_link x ;
			<S2, _ + #c + #v + #v + #c> => hjk_type_VI_link x ; -- rostbiif, not viiul
			<S2, _ + #v + #c + #c + #c> => hjk_type_VI_link x ; -- impulss
			<_, _ + #v + "s"> => hjk_type_Va_otsene x ;
			-- TODO: test if -m is better then -em
			-- Exclude: -am, -om, -um
			<_, _ + ("v"|"tav"|"em"|"im")> => hjk_type_IVb_audit x "a" ; -- kauneim
			<_, _ + ("line"|"lane"|"mine"|"kene")> => hjk_type_Vb_oluline x ;
			<S21, _ + "e"> => hjk_type_III_ratsu x ; -- k6ne
			<_, _ + "ne"> => hjk_type_Va_otsene x ;
			<S21, _ + #foreign_v> => hjk_type_III_ratsu x ; -- ufo, pita, lito
			<S21, _ + #v> => hjk_type_II_ema x ;
			<S22, _ + #v> => hjk_type_III_ratsu x ;
			<S23, _ + #v> => hjk_type_IVa_aasta x ;
			<S2, _ + "in"> => hjk_type_IVb_audit x "a" ;
			-- Handling of 'kringel' -> 'kringli', 'amper' -> 'ampri', 'meeter', 'reegel'
			-- kaabel-> kaabli (TODO: not: juubel -> juubli)
			-- spikker -> spikri (TODO: not: pokker -> pokkeri)
			-- Note: pintsel -> pintsli, but not pitser -> pitsri
			-- Note that 'redel' and 'paber' do not lose the 'e'.
			<S2, y + kk@("kk"|"pp"|"tt"|"hh") + "e" + l@("l"|"r")> => hjk_type_IVb_audit1 x (y + (init kk) + l) ;
			<S2, y + vv@(#vv) + gbd@(#gbd) + "e" + l@("l"|"r")> => hjk_type_IVb_audit1 x (y+vv+gbd+l) ;
			<S2, y + vv@(#vv) + s@("s") + "e" + l@("l"|"r")> => hjk_type_IVb_audit1 x (y+vv+s+l) ;
			<S2, y + n@("nts"|"ld"|"ng"|"nd"|"mb"|"k"|"p"|"t") + "e" + l@("l"|"r")> => hjk_type_IVb_audit1 x (y+n+l) ;
			<S2, y + "e" + l@("l"|"r") > => hjk_type_IVb_audit x "i" ;
			<S2, _ + #c> => hjk_type_IVb_audit x "i" ; -- TODO: masked by 'link'
			<S3, _ + #v> => hjk_type_IVa_aasta x ;
			<_, _ + "e"> => hjk_type_VII_touge x ; -- TODO: verb+e
			<_, _ + #c> => hjk_type_IVb_audit x "i" ; -- catch all that end with consonant
			<_, _> => hjk_type_III_ratsu x -- catch all
		} ;


	-- Assigns stress/quantity indicator to the word based on its character composition.
	-- Note that you cannot use recursion in these rules.
	-- Also, backreferences do not seem to work on the left-hand side, e.g. this works weird:
	-- #c + #v + #c + #c + i@(#v) + i + #c => S1 ; -- double vowel in the last syllable: vampiir, bensiin
	syl_type : Str -> SylType ;
	syl_type x =
		case x of {
			-- all 1-letters
			? => S1 ;
			-- all 2-letters
			? + ? => S1 ;
			-- all 3-letters
			#v + #c + #v => S21 ;
			#v + #v + #v => S2 ;
			? + ? + ? => S1 ; -- koi, kae
			-- all 4-letters
			#c + #v + #v + #c => S1 ; -- siid
			#c + #v + #c + #c => S1 ; -- link
			#v + #c + #v + #c => S2 ;
			#v + #vv + #c => S1 ; -- auul, ioon, oaas
			#v + #v + #v + #c => S2 ; -- aiak (?)
			#v + #v + #c + #v => S23 ; -- 6ige
			#v + #c + #v + #v => S1 ; -- epee, oboe
			#v + #c + #c + #v => S2 ;
			#c + #v + #c + #v => S21 ;
			? + ? + ? + ? => S1 ;
			-- all 5-letters
			#v + #c + #c + #v + #v => S1 ; -- armee
			#c + #v + #c + #v + #v => S1 ; -- depoo
			#c + #c + #v + #c + #c => S1 ; -- tramm
			#c + #v + #c + #c + #c => S1 ;
			#c + #v + #vv     + #c => S1 ; -- poeem
			#c + #v + #v + #v + #c => S2 ; -- hoius, laius, maius
			#c + #v + #c + #v + #c => S2 ; -- redel
			#c + #v + #c + #gbd + "e" => S23 ; -- valge
			#c + #v + #v + #gbd + "e" => S23 ; -- haige ?
			#c + #v + #c + #c + #v => S22 ; -- ratsu
			#v + #c + #c + #c + #v => S2 ;
			#v + #c + #c + #v + #c => S2 ; -- amper
			#v + #c + #v + #c + #c => S2 ; -- avang
			_ + #c + #vv + #c + #c => S1 ; -- loots (double vowel, otherwise the same as below)
			#c + #v + #v + #c + #c => S2 ; -- laeng, loend
			#c + #c + #v + #v + #c => S1 ; -- bluus, kruus, kreem
			#v + #c + #v + #v + #c => S1 ; -- ukaas, TODO: not 'avaus'
			#v + #v + #c + #v + #c => S2 ; -- aatom
			#v + #v + #c + #c + #v => S23 ; -- aasta
			#c + #c + #v + #c + #v => S21 ; -- blogi
			_ + ? + #v + #vv + #c => S1 ; -- -ioos, kruiis
			#c + #c + #v + #v + #v + #c => S2 ; -- flaier
			_ + ? + #c + #v + #c + #v => S3 ; -- oluline
			-- all 6-letters
			#v + #c + #c + #v + #v + #c => S1 ; -- aplaus
			#v + #c + #c + #v + #c + #c => S2 ; -- astang, ellips
			#c + #vv + #c + #v + #v => S23 ; -- muumia, raadio, TODO: exclude 'vaarao'
			#c + #v + #v + #c + #v + #v => S1 ; -- peoleo
			#c + #v + #c + #vv + #c => S1 ; -- deviis (double vowel in the last syllable)
			#v + #c + #v + #c + #v + #v => S1 ; -- agoraa
			#c + #v + #c + #v + #c + #c => S2 ;
			#c + #v + #c + #v + #c + #v => S3 ;
			#v + #c + #v + #c + #c + #v => S3 ; -- yheksa
			#c + #v + #c + #c + #v + #c => S2 ; -- rektor
			#c + #v + #c + #v + #v + #c => S2 ; -- paleus
			#c + #v + #v + #c + #v + #c => S2 ; -- meeter, reegel
			#v + #v + #c + #c + #v + #c => S2 ; -- aastak
			#v + #c + #c + #c + #v + #c => S2 ; -- andmik
			#v + #c + #c + #v + #c + #v => S3 ;
			_ + #v + #c + #v + #c + #v + #c => S3 ; -- alevik, elanik
			-- all 7-letters
			_ + ? + ? + #c + #vv + #c => S1 ; -- double vowel in the last syllable: bensiin, benseen, bensool
			#c + #v + #v + #c + #c + #v + #c => S2 ; -- jooksik
			#c + #v + #c + #c + #c + #v + #c => S2 ; -- hurtsik
			#c + #v + #c + #c + #v + #c + #c => S2 ; -- kitsend
			#c + #v + #c + #c + #v + #v + #c => S2 ; -- pension
			#c + #v + #c + #v + #c + #v + #c => S3 ; -- seminar
			#c + #c + #v + #c + #c + #v + #c => S2 ; -- kringel, plastik
			_ + #v + #c + #v + #kpt + #kpt + #v + #c => S2 ; -- elekter, adapter
			_ + #c + #v + #lmnr + #gbd + #v + #c => S2 ; -- (k)alender, (dets)ember
			_ + #c + #v + #lmnr + #kpt + #v + #c => S2 ; -- (re)porter
			_ + #c + #v + "stik" => S3 ; -- kuristik (TODO: not logistik)
			_ + #c + #v + "s" + #kpt + #v + #c => S2 ; -- (k)anister
			#v + #c + #v + #c + #c + #v + #c => S3 ; -- apelsin
			#v + #c + #c + #v + #c + #v + #c => S3 ; -- admiral
			#c + #v + #c + #v + #c + #c + #v => S3 ; -- kaheksa
			#c + #c + #v + #c + #v + #c + #c => S2 ; -- klopits
			#c + #v + #v + #c + #v + #c + #c => S2 ; -- haarang
			#c + #v + #v + #c + #v + #v + #c => S2 ; -- raadius, kauneim
			_ + #c + #v + #v + #c + #v + #c => S2 ; -- araabik
			_ + #lmnr + #gbd + #v + #c + #c + #v + #c => S3 ; -- (pa)lderjan, (ko)rgitser
			-- other
			_ + #c + #v + #c + #c + #v + #c + #v + #c => S3 ; -- karneval
			#c + #v + #c + #v + #c + #c + #v + #c => S3 ; -- ragastik (kalender is handled above)
			_ + #v + #v + #c + #v + #c + #c + #v + #c => S3 ; -- ainestik
			_ + #c + #c + #v + #c + #c + #v + #c + #c => S3 ; -- ampersand
			_ + #c + #v + #c + #v + #c + #c => S1 ; -- dividend
			_ + #v + #c + #c + #c + #v + #v => S1 ; -- displei
			_ + #c + #v + #c + #c + #v + #v => S1 ; -- politsei, nostalgia (?)
			     _ + #c + #v + #c + #v + #v => S1 ; -- defilee, kompanii
			_ => S2 -- the default is S2, but the above rules should catch most of the words
		} ;

}
