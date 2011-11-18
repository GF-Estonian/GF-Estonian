--# -path=.:prelude:../abstract:../common

concrete LexiconEst of Lexicon = CatEst ** open MorphoEst, ParadigmsEst in {

flags 
  optimize=values ; coding=utf8;


lin
  airplane_N = mkN "lennuk" "lennuki" "lennukit" "lennukeid";
  answer_V2S = mkV2 (mkV "vastata") (casePrep allative) ;
  apartment_N = mkN "korter" "korteri" "korterit" "kortereid";
  apple_N = mkN "õun" "õuna" "õuna" "õunu";
  art_N = mkN "kunst" "kunsti" "kunsti" "kunste";
  ask_V2Q = mkV2 (mkV "kysyä") (casePrep ablative) ;
  baby_N = mkN "beebi" "beebi" "beebit" "beebisid";
  bad_A = mkA (mkN "paha") "pahempi" "pahin" ;
  bank_N = mkN "pank" "panga" "panka" "panku";
  beautiful_A = mkA (mkN "kaunis") "kauniimpi" "kaunein" ;
  become_VA = mkVA (mkV "tulla") (casePrep translative) ;
  beer_N = mkN "õlu" "õlu" "õlut" "õlusid";
  beg_V2V = mkV2V (mk2V "pyytää" "pyysi") (casePrep partitive) ;
  big_A = mkA (mkN "suuri" "suuria") "suurempi" "suurin" ;
  bike_N = mkN "ratas" "ratta" "ratast" "rattaid";
  bird_N = mkN "lind" "linnu" "lindu" "linde";
  black_A = mkA (mkN "musta") "mustempi" "mustin" ;
  blue_A = mkA (mkN "sininen") "sinisempi" "sinisin" ;
  boat_N = mkN "paat" "paadi" "paati" "paate";
  book_N = mkN "raamat" "raamatu" "raamatut" "raamatuid" ;
  boot_N = mkN "saabas" "saapa" "saabast" "saapaid";
  boss_N = mkN "boss" "bossi" "bossi" "bosse" ;
  boy_N = mkN "poiss" "poisi" "poissi" "poisse";
  bread_N = mkN "leib" "leiva" "leiba" "leibu";
  break_V2 = mkV2 (mkV "rikkoa") ;
  broad_A = mkA (mkN "leveä") "leveämpi" "levein" ;
  brother_N2 = mkN2 (mkN "vend") ;
  brown_A = mkA (mkN "ruskea") "ruskeampi" "ruskein" ;
  butter_N = mkN "või" "või" "võid" "võisid";
  buy_V2 = mkV2 (mkV "ostaa") ;
  camera_N = mkN "kaamera" "kaamera" "kaamerat" "kaameraid";
  cap_N = mkN "müts" "mütsi" "mütsi" "mütse";
  car_N = mkN "auto" "auto" "autot" "autosid";
  carpet_N = mkN "vaip" "vaiba" "vaipa" "vaipu";
  cat_N = mkN "kass" "kassi" "kassi" "kasse";
  ceiling_N = mkN "lagi" "lae" "lage" "lagesid";
  chair_N = mkN "tool" "tooli" "tooli" "toole";
  cheese_N = mkN "juust" "juustu" "juustu" "juuste";
  child_N = mkN "laps" "lapse" "last" "lapsi" ;
  church_N = mkN "kirik" "kiriku" "kirikut" "kirikuid";
  city_N = mkN "linn" "linna" "linna" "linnu" ;
  -- above this line the N-words have been translated into Estonian

  clean_A = mkA (mkN "puhdas") ;
  clever_A = mkA (mkN "viisas") ;
  close_V2 = mkV2 (mkV "sulkea") ;
  coat_N = mkN "takki" ;
  cold_A = mkA (mkN "kylmä") "kylmempi" "kylmin" ;
  come_V = mkV "tulla" ;
  computer_N = mkN "tietokone" ;
  country_N = mkN "maa" ;
  cousin_N = mkN "serkku" ;
  cow_N = mkN "lehmä" ;
  die_V = mkV "kuolla" ;
  dirty_A = mkA (mkN "likainen") "likaisempi" "likaisin" ;
  distance_N3 = mkN3 (mkN "etäisyys") (casePrep elative) (casePrep illative) ;
  doctor_N = mk2N "tohtori" "tohtoreita" ;
  dog_N = mkN "koira" ;
  door_N = mkN "ovi" "ovia" ;
  drink_V2 = mkV2 (mkV "juoda") (casePrep partitive) ;
  easy_A2V = mkA2 (mkA (mkN "helppo") "helpompi" "helpoin") 
    (casePrep allative) ;
  eat_V2 = mkV2 (mkV "syödä") (casePrep partitive) ;
  empty_A = mkA (mkN "tyhjä") "tyhjempi" "tyhjin" ;
  enemy_N = mkN "vihollinen" ;
  factory_N = mkN "tehdas" ;
  father_N2 = mkN2 (mkN "isä") ;
  fear_VS = mkVS (mk2V "pelätä" "pelkäsi") ;
  find_V2 = mkV2 (mk2V "löytää" "löysi") ;
  fish_N = mkN "kala" ;
  floor_N = mk2N "lattia" "lattioita" ;
  forget_V2 = mkV2 (mkV "unohtaa") ;
  fridge_N = mkN "jääkaappi" ;
  friend_N = mkN "ystävä" ;
  fruit_N = mkN "hedelmä" ;
  fun_AV = mkAV (mkA (mkN "hauska") "hauskempi" "hauskin") ;
  garden_N = mkN "puutarha" "puutarhan" "puutarhoja" ;
  girl_N = mkN "tyttö" ;
  glove_N = mkN "käsine" ;
  gold_N = mkN "kulta" ;
  good_A = mkA (mkN "hyvä") "parempi" "parhain" ; --- paras
  go_V = mkV "mennä" ;
  green_A = mkA (mkN "vihreä") "vihreämpi" "vihrein" ;
  harbour_N = mkN "satama" "sataman" "satamia" ;
  hate_V2 = mkV2 (mkV "vihata") cpartitive ;
  hat_N = mkN "hattu" ;
  hear_V2 = mkV2 (mkV "kuulla") ;
  hill_N = mkN "kukkula" ;
  hope_VS = mkVS (mkV "toivoa") ;
  horse_N = mkN "hevonen" ;
  hot_A = mkA (mkN "kuuma") "kuumempi" "kuumin" ;
  house_N = mkN "talo" ;
  important_A = mkA (mkN "tärkeä") "tärkeämpi" "tärkein" ;
  industry_N = mkN "teollisuus" ;
  iron_N = mkN "rauta" ;
  king_N = mkN "kuningas" ;
  know_VS = mkVS (mkV "tietää" "tiesi") ;
  know_VQ = mkVQ (mkV "tietää" "tiesi") ;
  know_V2 = mkV2 (mkV "tuntea" "tunsi") ;
  lake_N = mkN "järvi" "järviä" ;
  lamp_N = mkN "lamppu" ;
  learn_V2 = 
    mkV2 (mk12V "oppia" "opin" "oppii" "oppivat" "oppikaa" "opitaan"
      "opin" "oppi" "oppisi" "oppinut" "opittu" "opitun") ;
  leather_N = mkN "nahka" ; --- nahan
  leave_V2 = mkV2 (mkV "jättää") ;
  like_V2 = mkV2 (mkV "pitää") elative ;
  listen_V2 = mkV2 (mkV "kuunnella" "kuunteli") partitive ;
  live_V = mkV "elää" ;
  long_A = mkA (mkN "pitkä") "pitempi" "pisin" ;
  lose_V2 = mkV2 (mkV "hävitä" "hävisi") ; --- hukata
  love_N = mk3N "rakkaus" "rakkauden" "rakkauksia" ;
  love_V2 = mkV2 (mkV "rakastaa") partitive ;
  man_N = mkN "mies" "miehen" "miestä" "miehiä" ; -- "miehenä" "mieheen" 
            --  "miesten" "miehiä" "miehinä" "miehissä" "miehiin" ; 
  married_A2 = mkA2 (mkA "avioitunut") (postPrep genitive "kanssa") ; ---- infl
  meat_N = mkN "liha" ;
  milk_N = mkN "maito" ;
  moon_N = mkN "kuu" ;
  mother_N2 = mkN2 (mkN "äiti") ;
  mountain_N = mkN "vuori" "vuoria" ;
  music_N = mkN "musiikki" ;
  narrow_A = mkA (mkN "kapea") "kapeampi" "kapein" ;
  new_A = mkA (mk3N "uusi" "uuden" "uusia") "uudempi" "uusin" ;
  newspaper_N = mkN "sanoma" (mkN "lehti" "lehtiä") ; --- for correct vowel harmony
  oil_N = mkN "öljy" ;
  old_A = mkA (mkN "vanha") "vanhempi" "vanhin" ;
  open_V2 = mkV2 (mkV "avata" "avasi") ;
  paint_V2A = mkV2A (mkV "maalata") accPrep (casePrep translative) ;
  paper_N = mk2N "paperi" "papereita" ;
  paris_PN = mkPN (mkN "Pariis") ;
  peace_N = mkN "rauha" ;
  pen_N = mkN "kynä" ;
  planet_N = mkN "planeetta" ;
  plastic_N = mkN "muovi" ;
  play_V2 = mkV2 (mkV "pelata") cpartitive ; --- leikkiä, soittaa
  policeman_N = mkN "poliisi" ;
  priest_N = mkN "pappi" ;
  probable_AS = mkAS --- for vowel harmony
    (mkA (mkN "todennäköinen") "tonennäköisempi" "todennäköisin") ; ---- sta
  queen_N = mkN "kuningatar" ;
  radio_N = mk2N "radio" "radioita" ;
  rain_V0 = mkV0 (mk2V "sataa" "satoi") ;
  read_V2 = mkV2 (mkV "lukea") ;
  red_A = mkA "punane" ;
  religion_N = mkN "uskonto" ;
  restaurant_N = mkN "ravintola" ;
  river_N = mkN "joki" "jokia" ;
  rock_N = mk2N "kallio" "kallioita" ;
  roof_N = mkN "katto" ;
  rubber_N = mkN "kumi" ;
  run_V = mk2V "juosta" "juoksi" ;
  say_VS = mkVS (mkV "sanoa") ;
  school_N = mkN "koulu" ;
  science_N = mkN "tiede" ;
  sea_N = mkN "meri" "meren" "meriä" "merta" ;
  seek_V2 = mkV2 (mkV "etsiä") cpartitive ;
  see_V2 = mkV2 (
    mk12V "nähdä" "näen" "näkee" "näkevät" "nähkää" "nähdään"
      "näin" "näki" "näkisi" "nähnyt" "nähty" "nähdyn") ; 
  sell_V3 = mkV3 (mkV "myydä") accPrep (casePrep allative) ;
  send_V3 = mkV3 (mkV "lähettää") accPrep (casePrep allative) ;
  sheep_N = mkN "lammas" ;
  ship_N = mkN "laiva" ;
  shirt_N = mkN "paita" ;
  shoe_N = mkN "kenkä" ;
  shop_N = mkN "kauppa" ;
  short_A = mkA (mkN "lyhyt" "lyhyitä") ;
  silver_N = mkN "hopea" ;
  sister_N = mkN "sisko" ;
  sleep_V = mkV "nukkua" ;
  small_A = mkA (mk2N "pieni" "pieniä") "pienempi" "pienin" ;
  snake_N = mkN "käärme" ;
  sock_N = mkN "sukka" ;
  speak_V2 = mkV2 (mkV "puhua") cpartitive ;
  star_N = mkN "tähti" "tähtiä" ;
  steel_N = mkN "teräs" ;
  stone_N = mkN "kivi" "kiviä" ;
  stove_N = mk3N "liesi" "lieden" "liesiä" ;
  student_N = mk2N "opiskelija" "opiskelijoita" ;
  stupid_A = mkA "tyhmä" ;
  sun_N = mkN "aurinko" ;
  switch8off_V2 = mkV2 (mkV "sammuttaa") ; ---
  switch8on_V2 = mkV2 (mkV "sytyttää") ; ---
  table_N = mkN "pöytä" ;
  talk_V3 = mkV3 (mkV "puhua") (casePrep allative) (casePrep elative) ;
  teacher_N = mkN "opettaja" ;
  teach_V2 = mkV2 (mkV "opettaa") ;
  television_N = mk2N "televisio" "televisioita" ;
  thick_A = mkA "paksu" ;
  thin_A = mkA (mkN "ohut" "ohuita") ;
  train_N = mkN "juna" ;
  travel_V = mkV "matkustaa" ;
  tree_N = mkN "puu" ;
 ---- trousers_N = mkN "trousers" ;
  ugly_A = mkA (mkN "ruma") "rumempi" "rumin" ;
  understand_V2 = mkV2 (mkV "ymmärtää" "ymmärrän" "ymmärsi") ;
  university_N = mkN "yliopisto" ;
  village_N = mkN "kylä" ;
  wait_V2 = mkV2 (mkV "odottaa") partitive ;
  walk_V = mkV "kävellä" "käveli" ;
  warm_A = mkA 
    (mkN "lämmin" "lämpimän" "lämmintä" "lämpimiä" ) --"lämpimänä" "lämpimään" 
--         "lämpiminä" "lämpimiä" "lämpimien" "lämpimissä" "lämpimiin"
--	 ) 
    "lämpimämpi" "lämpimin" ;
  war_N = mkN "sota" ;
  watch_V2 = mkV2 (mkV "katsella") cpartitive ;
  water_N = mk3N "vesi" "veden" "vesiä" ;
  white_A = mkA "valkoinen" ;
  window_N = mk2N "ikkuna" "ikkunoita" ;
  wine_N = mkN "viini" ;
  win_V2 = mkV2 (mkV "voittaa") ;
  woman_N = mkN "naine" ;
  wonder_VQ = mkVQ (mkV "ihmetellä") ;
  wood_N = mkN "puu" ;
  write_V2 = mkV2 (mkV "kirjoittaa") ;
  yellow_A = mkA "keltainen" ;
  young_A = mkA (mkN "nuori" "nuoria") "nuorempi" "nuorin" ;

  do_V2 = mkV2 (
    mkV "tehdä" "teen" "tekee" "tekevät" "tehkää" "tehdään"
      "tein" "teki" "tekisi" "tehnyt" "tehty" "tehdyn") ; 

  now_Adv = mkAdv "nüüd" ;
  already_Adv = mkAdv "juba" ;
  song_N = mkN "laulu" ;
  add_V3 = mkV3 (mkV "lisätä") accPrep (casePrep illative) ;
  number_N = mk2N "numero" "numeroita" ;
  put_V2 = mkV2 (mkV "panna") ;
  stop_V = mkV "pysähtyä" ;
  jump_V = mkV "hypätä" ;
  left_Ord = mkOrd (mkN "vasen") ;
  right_Ord = mkOrd (mkN "oikea") ;
  far_Adv = mkAdv "kaugel" ;
  correct_A = mkA "oikea" ;
  dry_A = mkA (mkN "kuiva") "kuivempi" "kuivin" ;
  dull_A = mkA (mkN "tylsä") "tylsempi" "tylsin" ;
  full_A = mkA (mk3N "täysi" "täyden" "täysiä") "täydempi" "täysin" ;
  heavy_A = mkA "raskas" ;
  near_A = mkA (mkN "läheinen") "läheisempi" "lähin" ;
  rotten_A = mkA "mätä" ;
  round_A = mkA "pyöreä" ;
  sharp_A = mkA "terävä" ;
  smooth_A = mkA "sileä" ;
  straight_A = mkA (mkN "suora") "suorempi" "suorin" ;
  wet_A = mkA (mkN "märkä") "märempi" "märin" ;
  wide_A = mkA "leveä" ;
  animal_N = mk3N "eläin" "eläimen" "eläimiä" ;
  ashes_N = mkN "tuhka" ;
  back_N = mkN "selkä" ;
  bark_N = mkN "kaarna" ;
  belly_N = mkN "vatsa" ;
  blood_N = mkN "veri" "veren" "veriä" "verta" ;
  bone_N = mkN "luu" ;
  breast_N = mkN "rinta" ;
  cloud_N = mk2N "pilvi" "pilviä" ;
  day_N = mkN "päivä" ;
  dust_N = mkN "pöly" ;
  ear_N = mkN "korva" ;
  earth_N = mkN "maa" ;
  egg_N = mkN "muna" ;
  eye_N = mkN "silmä" ;
  fat_N = mkN "rasva" ;
  feather_N = mk3N "höyhen" "höyhenen" "höyheniä" ;
  fingernail_N = mk3N "kynsi" "kynnen" "kynsiä" ;
  fire_N = mk2N "tuli" "tulia" ;
  flower_N = mkN "kukka" ;
  fog_N = mkN "sumu" ;
  foot_N = mkN "jalka" ;
  forest_N = mkN "metsä" ;
  grass_N = mkN "ruoho" ;
  guts_N = mkN "sisälmys" ; --- suoli
  hair_N = mkN "hius" ;
  hand_N = mk3N "käsi" "käden" "käsiä" ;
  head_N = mkN "pää" ;
  heart_N = mkN "sydän" ;  -- "sydämen" "sydäntä" "sydämenä" "sydämeen"
               -- "sydänten" "sydämiä" "sydäminä" "sydämissä" "sydämiin" ;
  horn_N = mk2N "sarvi" "sarvia" ;
  husband_N = man_N ; --mkN "mies" "miehen" "miestä" "miehenä" "mieheen" 
                      --"miesten" "miehiä" "miehinä" "miehissä" "miehiin" ; 
  ice_N = mkN "jää" ;
  knee_N = mk2N "polvi" "polvia" ;
  leaf_N = mk2N "lehti" "lehtiä" ;
  leg_N = mkN "jalka" ; --- sääri
  liver_N = mkN "maksa" ;
  louse_N = mkN "lude" ;
  mouth_N = mkN "suu" ;
  name_N = mk2N "nimi" "nimiä" ;
  neck_N = mkN "niska" ;
  night_N = mkN "yö" ;
  nose_N = mkN "nenä" ;
  person_N = mkN "henkilö" ;
  rain_N = mkN "sade" ;
  road_N = mkN "tie" ;
  root_N = mk2N "juuri" "juuria" ;
  rope_N = mk3N "köysi" "köyden" "köysiä" ;
  salt_N = mkN "suola" ;
  sand_N = mkN "hiekka" ;
  seed_N = mkN "siemen" ;
  skin_N = mkN "nahka" ;
  sky_N = mk3N "taivas" "taivaan" "taivaita" ;
  smoke_N = mkN "savu" ;
  snow_N = mkN "lumi" "lumen" "lumia" "lunta" ;
  stick_N = mkN "keppi" ;
  tail_N = mkN "häntä" ;
  tongue_N = mk2N "kieli" "kieliä" ;
  tooth_N = mkN "hammas" ;
  wife_N = mkN "vaimo" ;
  wind_N = mk2N "tuuli" "tuulia" ;
  wing_N = mk2N "siipi" "siipiä" ;
  worm_N = mkN "mato" ;
  year_N = mk3N "vuosi" "vuoden" "vuosia" ;
  bite_V2 = mkV2 (mkV "purra") ;
  blow_V = mkV "puhaltaa" ;
  burn_V = mkV "palaa" ;
  count_V2 = mkV2 (mkV "laskea") ;
  cut_V2 = mkV2 (mk2V "leikata" "leikkasi") ;
  dig_V = mkV "kaivaa" ;
  fall_V = mkV "pudota" "putoan" "putosi" ;
  fear_V2 = mkV2 (mkV "pelätä" "pelkään" "pelkäsi") cpartitive ;
  fight_V2 = mkV2 (mkV "taistella") (postPrep partitive "vastaan") ;
  float_V = mkV "kellua" ;
  flow_V = mkV "virrata" "virtaan" "virtasi" ;
  fly_V = mkV "lentää" ;
  freeze_V = mkV "jäätyä" ;
  give_V3 = mkV3 (mkV "antaa" "annan" "antoi") accPrep (casePrep allative) ;
  hit_V2 = mkV2 (mkV "lyödä") cpartitive ;
  hold_V2 = mkV2 (mkV "pitää") cpartitive ;
  hunt_V2 = mkV2 (mkV "metsästää") cpartitive ;
  kill_V2 = mkV2 (mkV "tappaa") ;
  laugh_V = mkV "nauraa" "nauroi" ;
  lie_V = mkV "maata" "makasi" ;
  play_V = mkV "pelata" ;
  pull_V2 = mkV2 (mkV "vetää") ;
  push_V2 = mkV2 (mkV "työntää") ;
  rub_V2 = mkV2 (mkV "hieroa") cpartitive ;
  scratch_V2 = mkV2 (mkV "raapia") cpartitive ;
  sew_V = mkV "kylvää" ;
  sing_V = mkV "laulaa" ;
  sit_V = mkV "istua" ;
  smell_V = mk2V "haista" "haisi" ;
  spit_V = mkV "sylkeä" ;
  split_V2 = mkV2 (mk2V "halkaista" "halkaisi") ;
  squeeze_V2 = mkV2 (mkV "puristaa") cpartitive ;
  stab_V2 = mkV2 (mkV "pistää") cpartitive ;
  stand_V = mk12V "seistä" "seison" "seisoo" "seisovat" "seiskää" "seistään"
      "seisoin" "seisoi" "seisoisi" "seissyt" "seisty" "seistyn" ; --- *seisoivät
  suck_V2 = mkV2 (mkV "imeä") cpartitive ;
  swell_V = mkV "turvota" "turposi" ;
  swim_V = mkV "uida" "uin" "ui" ;
  think_V = mkV "ajatella" "ajattelen" "ajatteli" ;
  throw_V2 = mkV2 (mkV "heittää") ;
  tie_V2 = mkV2 (mkV "sitoa") ;
  turn_V = mkV "kääntyä" ;
  vomit_V = mkV "oksentaa" ;
  wash_V2 = mkV2 (mkV "pestä") ;
  wipe_V2 = mkV2 (mkV "pyyhkiä") ;

  breathe_V = mkV "hengittää" ;

  grammar_N = mkN "kielioppi" ;
  language_N = mk2N "kieli" "kieliä" ;
  rule_N = mkN "sääntö" ;

    john_PN = mkPN "Juhan" ;
    question_N = mkN "kysymys" ;
    ready_A = mkA (mkN "valmis") ;
    reason_N = mkN "syy" ;
    today_Adv = mkAdv "täna" ;
    uncertain_A = mkA "epävarma" ;

 oper
    mkOrd : N -> Ord ;
    mkOrd x = {s = x.s ; lock_Ord = <> } ;
    cpartitive = casePrep partitive ;

} ;
