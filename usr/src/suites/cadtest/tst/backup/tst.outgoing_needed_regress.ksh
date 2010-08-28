$HG clone -q $REPOS/basews $REPOS/outgoing-needed
cd $REPOS/outgoing-needed

#
# First, with no extant outgoing node
#

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 250

echo "foo" >> b

$HG ci -m "Outgoing"		# Make a change
$HG up -C 0			# Go back to the prior dirstate node

# Should still notice we need a backup
($HG backup -t | grep 'backup is up-to-date') && exit 251

#
# Same again, with extant nodes file
#
$HG up -C tip

echo "foo" >> c

$HG ci -m "Outgoing 2"
$HG up -C 0

# Should still notice we need a backup
($HG backup -t | grep 'backup is up-to-date') && exit 251

exit 0				# So we don't exit as the grep above did
