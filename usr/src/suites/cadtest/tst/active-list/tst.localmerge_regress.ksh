$HG clone -q $REPOS/basews $REPOS/localmerge-regress
cd $REPOS/localmerge-regress

touch new_file
$HG add new_file
$HG ci -qm "Add new_file"

$HG up -qC 0

for i in *; do
	echo $i >> $i
done

$HG ci -qm "Modify files"

$HG -q merge

# If we picked a local node as the parenttip, we'll be missing one
# half of the changes above, most commonly the addition of new_file.
# Through that, we can check that we do have the full set of changes.
$HG list
