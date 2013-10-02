
# Work in progress

cp ../resources/ratsep.syh ratsep.utf8.syh
recode latin1..utf8 ratsep.utf8.syh

cat ratsep.utf8.syh |\
perl -pi -e 's/\r//g' |\
grep -v "^ " |\
grep -v '^!' |\
grep -v '^\$<s>' |\
tr '\012' ' ' |\
perl -pe 's/\$<\/s>/\n/g' |\
# Exclude quotes for the time begin
grep -v "&quot;" |\
# Include only sentences that contain a dot
grep "\." |\
# Remove dot(s)
sed "s/\.//g" |\
# Strip space
sed "s/^ *//" | sed 's/ *$//' |\
# Lowercase everything, incl. proper names
tr '[:upper:]' '[:lower:]' |\
sort |\
uniq |\
#sed 's/^/p "/' |\
#sed 's/$/"/'
cat
