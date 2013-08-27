--# -path=.:../abstract:../common

concrete LexiconEst of Lexicon = CatEst ** open MorphoEst, ParadigmsEst in {

flags 
  optimize=values ; coding=utf8;


lin
  airplane_N = mkN "lennuk" ;
  answer_V2S = mkV2 (mkV "vastama") (casePrep allative) ;
  apartment_N = mkN "korter" ;
  apple_N = mkN "õun" ;
  art_N = mkN "kunst" ;
  ask_V2Q = mkV2 (mkV "küsima") (casePrep ablative) ;
  baby_N = mkN "beebi" ;
  bad_A = mkA (mkN "halb" "halva" "halba" "halba" "halbade" "halbu") ;
  bank_N = mkN "pank" ;
  beautiful_A = mkA "kaunis" ;
  become_VA = mkVA (mkV "muutuma") (casePrep translative) ;
  beer_N = mkN "õlu" ;
  beg_V2V = mkV2V (mk2V "pyytää" "pyysi") (casePrep partitive) ;
  big_A = mkA "suur" ;
  bike_N = mkN "ratas" ;
  bird_N = mkN "lind" ;
  black_A = mkA "must" ;
  blue_A = mkA "sinine" ;
  boat_N = mkN "paat" ;
  book_N = mkN "raamat" ;
  boot_N = mkN "saabas" ;
  boss_N = mkN "boss" ;
  boy_N = mkN "poiss" ;
  bread_N = mkN "leib" ;
  break_V2 = mkV2 (mkV "rikkoa") ;
  broad_A = mkA "lai" ;
  brother_N2 = mkN2 (mkN "vend" "venna" "venda" "venda" "vendade" "vendi") ;
  brown_A = mkA "pruun" ;
  butter_N = mkN "või" ;
  buy_V2 = mkV2 (mkV "ostma") ;
  camera_N = mkN "kaamera" ;
  cap_N = mkN "müts" ;
  car_N = mkN "auto" ;
  carpet_N = mkN "vaip" ;
  cat_N = mkN "kass" ;
  ceiling_N = mkN "lagi" ;
  chair_N = mkN "tool" ;
  cheese_N = mkN "juust" ;
  child_N = mkN "laps" "lapse" "last" "lapsesse" "laste" "lapsi" ;
  church_N = mkN "kirik" ;
  city_N = mkN "linn" ;
  clean_A = mkA "puhas" ;
  clever_A = mkA "tark" ;
  close_V2 = mkV2 (mkV "sulgema") ;
  coat_N = mkN "mantel" ;
  cold_A = mkA "külm" ;
  come_V = mkV "tulema" ;
  computer_N = mkN "arvuti" ;
  country_N = mkN "maa" ;
  cousin_N = mkN "nõbu" ;
  cow_N = mkN "lehm" ;
  die_V = mkV "surema" ;
  dirty_A = mkA "must" ;
  distance_N3 = mkN3 (mkN "kaugus") (casePrep elative) (casePrep illative) ;
  doctor_N = mkN "arst" ;
  dog_N = mkN "koer" ;
  door_N = mkN "uks" ;
  drink_V2 = mkV2 (mkV "jooma") (casePrep partitive) ;
  easy_A2V = mkA2 (mkA (mkN "helppo") "helpompi" "helpoin") 
    (casePrep allative) ;
  eat_V2 = mkV2 (mkV "sööma") (casePrep partitive) ;
  empty_A = mkA "tühi" ;
  enemy_N = mkN "vaenlane" ;
  factory_N = mkN "tehas" ;
  father_N2 = mkN2 (mkN "isa") ;
  fear_VS = mkVS (mk2V "pelätä" "pelkäsi") ;
  find_V2 = mkV2 (mk2V "löytää" "löysi") ;
  fish_N = mkN "kala" ;
  floor_N = mkN "põrand" ;
  forget_V2 = mkV2 (mkV "unustama") ;
  fridge_N = mkN "külm" (mkN "kapp") ;
  friend_N = mkN "sõber" ;
  fruit_N = mkN "puu" (mkN "vili") ;
  fun_AV = mkAV (mkA (mkN "hauska") "hauskempi" "hauskin") ;
  garden_N = mkN "aed" ;
  girl_N = mkN "tüdruk" ;
  glove_N = mkN "kinnas" ;
  gold_N = mkN "kuld" ;
  good_A = mkA (mkN "hea") "parem" "parim" ;
  go_V = mk12V "minna" "lähen" "läheb" "lähevad" "mingu" "TODO"
      "läksin" "läks" "läheks" "TODO" "TODO" "TODO" ;
  green_A = mkA "roheline" ;
  harbour_N = mkN "sadam" ;
  hate_V2 = mkV2 (mkV "vihkama") cpartitive ;
  hat_N = mkN "müts" ;
  hear_V2 = mkV2 (mkV "kuulma") ;
  hill_N = mkN "mägi" ;
  hope_VS = mkVS (mkV "lootma") ;
  horse_N = mkN "hobune" ;
  hot_A = mkA "kuum" ;
  house_N = mkN "maja" ;
  important_A = mkA "tähtis" ;
  industry_N = mkN "tööstus" ;
  iron_N = mkN "raud" ;
  king_N = mkN "kuningas" ;
  know_VS = mkVS (mkV "teadma") ;
  know_VQ = mkVQ (mkV "tietää" "tiesi") ;
  know_V2 = mkV2 (mkV "tuntea" "tunsi") ;
  lake_N = mkN "järv" ;
  lamp_N = mkN "lamp" ;
  learn_V2 = 
    mkV2 (mk12V "oppia" "opin" "oppii" "oppivat" "oppikaa" "opitaan"
      "opin" "oppi" "oppisi" "oppinut" "opittu" "opitun") ;
  leather_N = mkN "nahk" ;
  leave_V2 = mkV2 (mkV "jättää") ;
  -- TODO: fix this: either use a 2-arg oper to handle to splittable verb 'lugupidada'
  -- or use 'meeldida' but in this case 'elative' cannot be used.
  like_V2 = mkV2 (mkV "lugupidama") elative ;
  listen_V2 = mkV2 (mkV "kuunnella" "kuunteli") partitive ;
  live_V = mkV "elama" ;
  long_A = mkA "pikk" ;
  lose_V2 = mkV2 (mkV "hävitä" "hävisi") ; --- hukata
  love_N = mkN "armastus" ;
  love_V2 = mkV2 (mkV "armastama") partitive ;
  man_N = mkN "mees" ;
  married_A2 = mkA2 (mkA "avioitunut") (postPrep genitive "kanssa") ; ---- infl
  meat_N = mkN "liha" ;
  milk_N = mkN "piim" ;
  moon_N = mkN "kuu" ;
  mother_N2 = mkN2 (mkN "ema") ;
  mountain_N = mkN "mägi" ;
  music_N = mkN "muusika" ;
  narrow_A = mkA "kitsas" ;
  new_A = mkA "uus" ;
  newspaper_N = mkN "aja" (mkN "leht") ;
  oil_N = mkN "õli" ;
  old_A = mkA "vana" ;
  open_V2 = mkV2 (mkV "avama") ;
  paint_V2A = mkV2A (mkV "maalata") accPrep (casePrep translative) ;
  paper_N = mkN "paber" ;
  paris_PN = mkPN (mkN "Pariis") ;
  peace_N = mkN "rahu" ;
  pen_N = mkN "pastakas" ;
  planet_N = mkN "planeet" ;
  plastic_N = mkN "kile" ;
  play_V2 = mkV2 (mkV "mängima") cpartitive ;
  policeman_N = mkN "politseinik" ;
  priest_N = mkN "preester" ;
  probable_AS = mkAS
    (mkA (mkN "todennäköinen") "tonennäköisempi" "todennäköisin") ;
  queen_N = mkN "kuninganna" ;
  radio_N = mkN "raadio" ;
  rain_V0 = mkV0 (mk2V "sadama" "sadas") ;
  read_V2 = mkV2 (mkV "lugema") ;
  red_A = mkA "punane" ;
  religion_N = mkN "usk" ;
  restaurant_N = mkN "restoran" ;
  river_N = mkN "jõgi" ;
  rock_N = mkN "kalju" ;
  roof_N = mkN "katus" ;
  rubber_N = mkN "kumm" ;
  run_V = mk2V "jooksma" "jooksis" ;
  say_VS = mkVS (mkV "sanoa") ;
  school_N = mkN "kool" ;
  science_N = mkN "teadus" ;
  sea_N = mkN "meri" ;
  seek_V2 = mkV2 (mkV "etsiä") cpartitive ;
  see_V2 = mkV2 (
    mk12V "nähdä" "näen" "näkee" "näkevät" "nähkää" "nähdään"
      "näin" "näki" "näkisi" "nähnyt" "nähty" "nähdyn") ; 
  sell_V3 = mkV3 (mkV "myydä") accPrep (casePrep allative) ;
  send_V3 = mkV3 (mkV "lähettää") accPrep (casePrep allative) ;
  sheep_N = mkN "lammas" ;
  ship_N = mkN "laev" ;
  shirt_N = mkN "särk" ;
  shoe_N = mkN "king" ;
  shop_N = mkN "kauplus" ;
  short_A = mkA "lühike" ;
  silver_N = mkN "hõbe" ;
  sister_N = mkN "õde" ;
  sleep_V = mkV "magama" ;
  small_A = mkA "väike" ;
  snake_N = mkN "uss" ;
  sock_N = mkN "sukk" ;
  speak_V2 = mkV2 (mkV "puhua") cpartitive ;
  star_N = mkN "täht" ;
  steel_N = mkN "teras" ;
  stone_N = mkN "kivi" ;
  stove_N = mkN "ahi" ;
  student_N = mkN "tudeng" ;
  stupid_A = mkA "loll" ;
  sun_N = mkN "päike" ;
  switch8off_V2 = mkV2 (mkV "sammuttaa") ;
  switch8on_V2 = mkV2 (mkV "sytyttää") ;
  table_N = mkN "laud" ;
  talk_V3 = mkV3 (mkV "puhua") (casePrep allative) (casePrep elative) ;
  teacher_N = mkN "õpetaja" ;
  teach_V2 = mkV2 (mkV "opettaa") ;
  television_N = mkN "televisioon" ;
  thick_A = mkA "paks" ;
  thin_A = mkA "õhuke" ;
  train_N = mkN "rong" ;
  travel_V = mkV "matkustaa" ;
  tree_N = mkN "puu" ;
  ugly_A = mkA "kole" ;
  understand_V2 = mkV2 (mkV "ymmärtää" "ymmärrän" "ymmärsi") ;
  university_N = mkN "ülikool" ;
  village_N = mkN "küla" ;
  wait_V2 = mkV2 (mkV "ootama") partitive ;
  walk_V = mkV "kõndima" ;
  warm_A = mkA "soe" ;
  war_N = mkN "sõda" ;
  watch_V2 = mkV2 (mkV "vaatama") cpartitive ;
  water_N = mkN "vesi" ;
  white_A = mkA "valge" ;
  window_N = mkN "aken" ;
  wine_N = mkN "vein" ;
  win_V2 = mkV2 (mkV "voittaa") ;
  woman_N = mkN "naine" ;
  wonder_VQ = mkVQ (mkV "ihmetellä") ;
  wood_N = mkN "puu" ;
  write_V2 = mkV2 (mkV "kirjutama") ;
  yellow_A = mkA "kollane" ;
  young_A = mkA "noor" ;

  do_V2 = mkV2 (
    mkV "tehdä" "teen" "tekee" "tekevät" "tehkää" "tehdään"
      "tein" "teki" "tekisi" "tehnyt" "tehty" "tehdyn") ; 

  now_Adv = mkAdv "nüüd" ;
  already_Adv = mkAdv "juba" ;
  song_N = mkN "laul" ;
  add_V3 = mkV3 (mkV "lisätä") accPrep (casePrep illative) ;
  number_N = mkN "number" ;
  put_V2 = mkV2 (mkV "panema") ;
  stop_V = mkV "pysähtyä" ;
  jump_V = mkV "hüppama" ;
  left_Ord = mkOrd (mkN "vasen") ;
  right_Ord = mkOrd (mkN "oikea") ;
  far_Adv = mkAdv "kaugel" ;
  correct_A = mkA "õige" ;
  dry_A = mkA "kuiv" ;
  dull_A = mkA "igav" ;
  full_A = mkA "täis" ;
  heavy_A = mkA "raske" ;
  near_A = mkA "lähedane" ;
  rotten_A = mkA "mäda" ;
  round_A = mkA "ümmargune" ;
  sharp_A = mkA "terav" ;
  smooth_A = mkA "sile" ;
  straight_A = mkA "sirge" ;
  wet_A = mkA "märg" ;
  wide_A = mkA "lai" ;
  animal_N = mkN "loom" ;
  ashes_N = mkN "tuhk" ;
  back_N = mkN "selg" ;
  bark_N = mkN "koor" ;
  belly_N = mkN "kõht" ;
  blood_N = mkN "veri" ;
  bone_N = mkN "luu" ;
  breast_N = mkN "rind" ;
  cloud_N = mkN "pilv" ;
  day_N = mkN "päev" ;
  dust_N = mkN "tolm" ;
  ear_N = mkN "kõrv" ;
  earth_N = mkN "maa" ;
  egg_N = mkN "muna" ;
  eye_N = mkN "silm" ;
  fat_N = mkN "rasv" ;
  feather_N = mkN "sulg" ;
  fingernail_N = mkN "küüs" ;
  fire_N = mkN "tuli" ;
  flower_N = mkN "lill" ;
  fog_N = mkN "udu" ;
  foot_N = mkN "jalg" ;
  forest_N = mkN "mets" ;
  grass_N = mkN "rohi" ;
  guts_N = mkN "soolestik" ;
  hair_N = mkN "juuksed" ; -- TODO: plural
  hand_N = mkN "käsi" ;
  head_N = mkN "pea" ;
  heart_N = mkN "süda" ;
  horn_N = mkN "sarv" ;
  husband_N = man_N ;
  ice_N = mkN "jää" ;
  knee_N = mkN "põlv" ;
  leaf_N = mkN "leht" ;
  leg_N = mkN "jalg" ;
  liver_N = mkN "maks" ;
  louse_N = mkN "täi" ;
  mouth_N = mkN "suu" ;
  name_N = mkN "nimi" ;
  neck_N = mkN "kael" ;
  night_N = mkN "öö" ;
  nose_N = mkN "nina" ;
  person_N = mkN "inimene" ;
  rain_N = mkN "vihm" ;
  road_N = mkN "tee" ;
  root_N = mkN "juur" ;
  rope_N = mkN "köis" ;
  salt_N = mkN "sool" ;
  sand_N = mkN "liiv" ;
  seed_N = mkN "seeme" ;
  skin_N = mkN "nahk" ;
  sky_N = mkN "taevas" ;
  smoke_N = mkN "suits" ;
  snow_N = mkN "lumi" ;
  stick_N = mkN "kepp" ;
  tail_N = mkN "saba" ;
  tongue_N = mkN "keel" ;
  tooth_N = mkN "hammas" ;
  wife_N = mkN "naine" ;
  wind_N = mkN "tuul" ;
  wing_N = mkN "tiib" ;
  worm_N = mkN "uss" ;
  year_N = mkN "aasta" ;
  bite_V2 = mkV2 (mkV "purema") ;
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
  play_V = mkV "mängima" ;
  pull_V2 = mkV2 (mkV "vetää") ;
  push_V2 = mkV2 (mkV "työntää") ;
  rub_V2 = mkV2 (mkV "hieroa") cpartitive ;
  scratch_V2 = mkV2 (mkV "raapia") cpartitive ;
  sew_V = mkV "kylvää" ;
  sing_V = mkV "laulma" ;
  sit_V = mkV "istuma" ;
  smell_V = mk2V "haista" "haisi" ;
  spit_V = mkV "sylkeä" ;
  split_V2 = mkV2 (mk2V "halkaista" "halkaisi") ;
  squeeze_V2 = mkV2 (mkV "puristaa") cpartitive ;
  stab_V2 = mkV2 (mkV "pistää") cpartitive ;
  stand_V = mk12V "seistä" "seison" "seisoo" "seisovat" "seiskää" "seistään"
      "seisoin" "seisoi" "seisoisi" "seissyt" "seisty" "seistyn" ;
  suck_V2 = mkV2 (mkV "imeä") cpartitive ;
  swell_V = mkV "turvota" "turposi" ;
  swim_V = mkV "ujuma" ;
  think_V = mkV "ajatella" "ajattelen" "ajatteli" ;
  throw_V2 = mkV2 (mkV "heittää") ;
  tie_V2 = mkV2 (mkV "siduma") ;
  turn_V = mkV "kääntyä" ;
  vomit_V = mkV "oksendama" ;
  wash_V2 = mkV2 (mkV "pesema") ;
  wipe_V2 = mkV2 (mkV "pyyhkiä") ;

  breathe_V = mkV "hengittää" ;

  grammar_N = mkN "grammatika" ;
  language_N = mkN "keel" ;
  rule_N = mkN "reegel" ;

  john_PN = mkPN "Juhan" ;
  question_N = mkN "küsimus" ;
  ready_A = mkA "valmis" ;
  reason_N = mkN "põhjus" ;
  today_Adv = mkAdv "täna" ;
  uncertain_A = mkA "ebakindel" ;

 oper
    mkOrd : N -> Ord ;
    mkOrd x = {s = x.s ; lock_Ord = <> } ;
    cpartitive = casePrep partitive ;

} ;
