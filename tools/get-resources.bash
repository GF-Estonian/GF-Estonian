
resources="../resources/"
resources_emwv=${resources}emwv/

mkdir -p ${resources_emwv}

curl http://www.cl.ut.ee/ressursid/pysiyhendid/DB_EMWV_2008.zip > ${resources_emwv}DB_EMWV_2008.zip
unzip ${resources_emwv}DB_EMWV_2008.zip
mv DB_EMWV_2008.txt ${resources_emwv}

curl http://www.cl.ut.ee/ressursid/teksaurus/failid/kb67a.zip > ${resources}/kb67a.zip
unzip -d ${resources} ${resources}/kb67a.zip
