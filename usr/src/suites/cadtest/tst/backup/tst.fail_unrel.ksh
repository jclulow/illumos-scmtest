$HG init $REPOS/unrelated
cd $REPOS/unrelated

#
# Should fail, as these two workspaces are unrelated (or, depending
# upon your point of view, the 'unrelated' workspace is missing a
# changeset)
#
$HG restore circ-rename 2>test.err
res=$?

sed -e "s/'[a-f0-9]\{12\}'/'<node>'/" test.err >&2

if [[ $res != 0 ]]; then
	exit 0
else
	exit 255
fi
