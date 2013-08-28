resource HjkEst = open ResEst, Prelude, Predef in {

  flags
	coding = utf8 ;

  -- TODO: change the name of this file and the names of the opers in this file

  param
	SylCount = S1 | S2 | S21 | S22 | S23 | S3 ;

  oper

	NFS = {s : NForm => Str} ;

	foreign : pattern Str = #("z" | "ž" | "š") ;
	v : pattern Str = #("a" | "e" | "i" | "o" | "u" | "õ" | "ä" | "ö" | "ü") ;
	c : pattern Str = #("m" | "n" | "p" | "b" | "t" | "d" | "k" | "g" | "f" | "v" | "s" | "h" | "l" | "j" | "r" | "z" | "ž" | "š") ;
	lmnr : pattern Str = #("l" | "m" | "n" | "r") ;
	kpt : pattern Str = #("k" | "p" | "t" | "f" | "š") ;
	gbd : pattern Str = #("g" | "b" | "d") ;

	hjk_type_I_koi : Str -> NFS ;

	hjk_type_I_koi x =
		hjk_nForms6 x x (x+"d") (x+"sse") (x+"de") (x+"sid") ;


	hjk_type_II_ema : Str -> NFS ;

	hjk_type_II_ema x =
		hjk_nForms6 x x x (x+"sse") (x+"de") (x+"sid") ;


	hjk_type_III_ratsu : Str -> NFS ;

	hjk_type_III_ratsu x =
		hjk_nForms6 x x (x+"t") (x+"sse") (x+"de") (x+"sid") ;


	hjk_type_IVa_aasta : Str -> NFS ;

	hjk_type_IVa_aasta x =
		hjk_nForms6 x x (x+"t") (x+"sse") (x+"te") (x+"id") ;


	hjk_type_IVb_audit : Str -> Str -> NFS ;

	hjk_type_IVb_audit x v_g =
		let
			v_pl = case v_g of { "i" => "e" ; _ => v_g }
		in
		hjk_nForms6 x (x+v_g) (x+v_g+"t") (x+v_g+"sse") (x+v_g+"te") (x+v_pl+"id") ;


	hjk_type_IVb_maakas : Str -> NFS ;

	hjk_type_IVb_maakas x =
		let
			gen = init x
		in
		hjk_nForms6 x gen (gen+"t") (gen+"sse") (gen+"te") (gen+"id") ;


	-- TODO: variant: vastusesse | vastusse
	hjk_type_Va_otsene : Str -> NFS ;

	hjk_type_Va_otsene x =
		let
			f : Str = case x of { y + "ne" => y + "s" ; _ => x }
		in
		hjk_nForms6 x (f+"e") (f+"t") (f+"esse") (f+"te") (f+"eid") ;


	-- TODO: variant: olulisesse | olulisse
	hjk_type_Vb_oluline : Str -> NFS ;

	hjk_type_Vb_oluline x =
		let
			f : Str = case x of { y + "ne" => y + "s" ; _ => x }
		in
		hjk_nForms6 x (f+"e") (f+"t") (f+"esse") (f+"te") (f+"i") ;


	hjk_type_VI_link : Str -> NFS ;

	hjk_type_VI_link x =
		let
			x_n : Str = weaker x
		in
		hjk_nForms6 x (x_n+"i") (x+"i") (x+"i") (x+"ide") (x+"e") ;


	hjk_type_VI_imelik : Str -> NFS ;

	hjk_type_VI_imelik x =
		let
			x_t : Str = stronger x
		in
		hjk_nForms6 x (x+"u") (x_t+"u") (x_t+"u") (x+"e") (x_t+"e") ;


	hjk_type_VI_meeskond : Str -> NFS ;

	hjk_type_VI_meeskond x =
		let
			x_n : Str = weaker x
		in
		hjk_nForms6 x (x_n+"a") (x+"a") (x+"a") (x+"ade") (x+"i") ;


	hjk_type_VI_seminar : Str -> NFS ;

	hjk_type_VI_seminar x =
		hjk_nForms6 x (x+"i") (x+"i") (x+"i") (x+"ide") (x+"e") ;


	hjk_type_VII_touge : Str -> NFS ;

	hjk_type_VII_touge x =
		let
			x_t : Str = stronger x
		in
		hjk_nForms6 x x_t (x+"t") (x_t+"sse") (x+"te") (x_t+"id") ;


	-- Converts 6 given strings (Nom, Gen, Part, Illat, Gen, Part) into Noun
	-- http://www.eki.ee/books/ekk09/index.php?p=3&p1=5&id=226
	hjk_nForms6 : (jogi,joe,joge,joesse,jogede,jogesid : Str) -> {s : NForm => Str} ;

	hjk_nForms6 jogi joe joge joesse jogede jogesid = {s = table {
		NCase Sg Nom    => jogi ;
		NCase Sg Gen    => joe ;
		NCase Sg Part   => joge ;
		NCase Sg Transl => joe + "ks" ;
		NCase Sg Ess    => joe + "na" ;
		NCase Sg Iness  => joe + "s" ;
		NCase Sg Elat   => joe + "st" ;
		NCase Sg Illat  => joesse ;
		NCase Sg Adess  => joe + "l" ;
		NCase Sg Ablat  => joe + "lt" ;
		NCase Sg Allat  => joe + "le" ;
		NCase Sg Abess  => joe + "ta" ;
		NCase Sg Comit  => joe + "ga" ;
		NCase Sg Termin => joe + "ni" ;

		NCase Pl Nom    => joe + "d" ;
		NCase Pl Gen    => jogede ;
		NCase Pl Part   => jogesid ;
		NCase Pl Transl => jogede + "ks" ;
		NCase Pl Ess    => jogede + "na" ;
		NCase Pl Iness  => jogede + "s" ;
		NCase Pl Elat   => jogede + "st" ;
		NCase Pl Illat  => jogede + "sse" ;
		NCase Pl Adess  => jogede + "l" ;
		NCase Pl Ablat  => jogede + "lt" ;
		NCase Pl Allat  => jogede + "le" ;
		NCase Pl Abess  => jogede + "ta" ;
		NCase Pl Comit  => jogede + "ga" ;
		NCase Pl Termin => jogede + "ni"
	} } ;


	-- TODO: implement fully
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
			V@(#v) + "k" => li + V + "g" ;
			V@(#v) + "p" => li + V + "b" ;
			V@(#v) + "t" => li + V + "d" ;
			V@(#v) + "d" => li + V ; --hoidma,hoiab
			N@(#lmnr) + "k" => li + N + "g" ;
			N@(#lmnr) + "p" => li + N + "b" ;
			N@(#lmnr) + "t" => li + N + "d" ;
			N@(#lmnr) + "d" => li + N + N ;
			"sk" => li + "s" ;
			"h" + #kpt => li + "h" ;
			"nd" => li + "nn" ;
			"ad" => li + "aj" ;
			"mb" => li + "mm" ;
			("ug"|"ub") => li + "o" ;
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
			sc = syl_count x
		in
		case <sc,x> of {
			<_, _ + #v + #v> => hjk_type_I_koi x ;
			<_, _ + ("lik"|"nik"|"stik")> => hjk_type_VI_imelik x ;
			<_, _ + ("kond")> => hjk_type_VI_meeskond x ;
			<_, _ + "nna"> => hjk_type_III_ratsu x ;
			<_, _ + ("nu"|"tu")> => hjk_type_IVa_aasta x ;
			<_, _ + ("kas"|"jas"|"nud"|"tud")> => hjk_type_IVb_maakas x ;
			<_, _ + ("us"|"is")> => hjk_type_Vb_oluline x ;
			<_, _ + #v + "s"> => hjk_type_Va_otsene x ;
			<_, _ + ("v"|"tav"|"em"|"im")> => hjk_type_IVb_audit x "a" ;
			<_, _ + ("line"|"lane"|"mine"|"kene")> => hjk_type_Vb_oluline x ;
			<S21, _ + "e"> => hjk_type_III_ratsu x ; -- k6ne
			<_, _ + "ne"> => hjk_type_Va_otsene x ;
			<S2, _ + #v> => hjk_type_II_ema x ; -- TODO 1st quant
			<S22, _ + #v> => hjk_type_III_ratsu x ;
			<S23, _ + #v> => hjk_type_IVa_aasta x ;
			<S2, _ + #foreign + _ + "in"> => hjk_type_IVb_audit x "i" ; -- TODO: better foreign detection
			<S2, _ + "in"> => hjk_type_IVb_audit x "a" ;
			<S2, _ + ("a"|"e"|"i") + ("ng"|"k")> => hjk_type_IVb_audit x "u" ;
			<S3, _ + #c + #v + #lmnr> => hjk_type_VI_seminar x ;
			<S1, _ + #v + #c + #c + #c> => hjk_type_VI_link x ;
			<S1, _ + #v + #c + #c> => hjk_type_VI_link x ;
			<S1, _ + #v + #v + #c> => hjk_type_VI_link x ;
			<S3, _ + #v + #c + #c + #c> => hjk_type_VI_link x ;
			<S3, _ + #v + #c + #c> => hjk_type_VI_link x ;
			<S3, _ + #v + #v + #c> => hjk_type_VI_link x ;
			--<S2, _ + #v + #c + #c + #c> => hjk_type_VI_link x ; -- TODO: last syl long
			--<S2, _ + #v + #c + #c> => hjk_type_VI_link x ;
			--<S2, _ + #v + #v + #c> => hjk_type_VI_link x ;
			<S2, _ + #c> => hjk_type_IVb_audit x "i" ;
			<S3, _ + #v> => hjk_type_IVa_aasta x ;
			<_, _ + "e"> => hjk_type_VII_touge x ; -- TODO: verb+e
			<_, _> => hjk_type_II_ema x -- TODO: what is the best catch all?
		} ;


	syl_count : Str -> SylCount ;
	syl_count x =
		case x of {
			-- all 1-letters
			? => S1 ;
			-- all 2-letters
			? + ? => S1 ;
			-- all 3-letters
			#v + #c + #v => S2 ;
			#v + #v + #v => S2 ;
			? + ? + ? => S1 ;
			-- all 4-letters
			#c + #v + #v + #c => S1 ; -- siid
			#c + #v + #c + #c => S1 ; -- link
			#v + #v + #c + #v => S23 ; -- 6ige
			#v + #c + #v + #v => S2 ;
			#v + #c + #v + #c => S2 ;
			#v + #c + #c + #v => S2 ;
			#c + #v + #c + #v => S21 ;
			? + ? + ? + ? => S1 ;
			-- all 5-letters
			#c + #v + #c + #c + #c => S1 ;
			#c + #v + #c + #v + #c => S2 ;
			#c + #v + #c + #gbd + "e" => S23 ; -- valge
			#c + #v + #v + #gbd + "e" => S23 ; -- haige ?
			#c + #v + #c + #c + #v => S22 ; -- ratsu
			#v + #c + #c + #c + #v => S2 ;
			#v + #v + #c + #v + #c => S2 ;
			#v + #v + #c + #c + #v => S23 ; -- aasta
			#c + #c + #v + #c + #v => S2 ; -- blogi
			_ + ? + #c + #v + #c + #v => S3 ; -- oluline
			-- all 6-letters
			#c + #v + #c + #v + #c + #c => S2 ;
			#c + #v + #c + #v + #c + #v => S3 ;
			#c + #v + #c + #c + #v + #c => S2 ;
			#v + #c + #c + #v + #c + #v => S3 ;
			-- all 7-letters
			#c + #v + #c + #c + #v + #v + #c => S2 ; -- pension
			#c + #v + #v + #c + #v + #c + #c => S2 ; -- haarang
			-- other
			_ => S3
		} ;

	-- Recursion is not allowed
	--B@(_ + #v + #v) + E@(#v + _) => add_syl_count (syl_count B) (syl_count E) ;
	add_syl_count : SylCount -> SylCount -> SylCount ;
	--add_syl_count S1 S1 = S2 ;
	--add_syl_count _ _ = S3 ;
	add_syl_count x y =
		case <x,y> of {
			<S1,S1> => S2 ;
			_ => S3
		} ;
}
