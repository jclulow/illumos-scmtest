if [[ -z "$1" ]]; then
	print -u2 "Usage: constant_pdiff <worksapce>"
	exit 2
fi

cd $1
$HG pdiff | perl -npe 's/^diff.*/diff/; s/^([-+]{3}) ([^\s]+)\s.*$/$1 $2/'
