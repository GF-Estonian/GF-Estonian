resource HjkEst = open ResEst, Prelude in {

  -- TODO: change the name of this file and the names of the opers in this file

  oper

	NFS = {s : NForm => Str} ;

	vowel : pattern Str = #("a" | "e" | "i" | "o") ;

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

}
