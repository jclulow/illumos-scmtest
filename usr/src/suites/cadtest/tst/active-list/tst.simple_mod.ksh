$HG -q clone $BASEWS $REPOS/simple-mod
cd $REPOS/simple-mod
echo "With an extra line" >> a

sed -e 's/This/This here/' < b > b.tmp
mv b.tmp b

sleep 1

sed -e 's/././g' < c > c.tmp
mv c.tmp c

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list

