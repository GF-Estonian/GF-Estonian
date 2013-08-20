resource HjkEst = open ResEst, Prelude, Predef in {

  -- TODO: change the name of this file and the names of the opers in this file

  oper

	NFS = {s : NForm => Str} ;

	vowel : pattern Str = #("a" | "e" | "i" | "o" | "u") ;

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
	weaker x =
		case x of {
			y + "kk" => y + "k" ;
			y + "pp" => y + "p" ;
			y + "tt" => y + "t" ;
			y + "ss" => y + "s" ;
			y + "k" => y + "g" ;
			y + "t" => y + "d" ;
			y + "p" => y + "b" ;
			_ => x
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

}
