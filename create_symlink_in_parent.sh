dir0="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

fn_stoponerror () {
#usage:
# fn_stoponerror "$?" $LINENO
ecode=$1
lNo=$2
if [ $ecode -ne 0 ]; then
        printf '%s\n\n' "$lNo: error [$1]"
        exit $ecode
else
       printf '%s\n' "$lNo success"
fi
}

php_executable="$dir0/bin/php"

$php_executable --version
fn_stoponerror "$?" $LINENO

parentdir="$(dirname $dir0)"
fn_stoponerror "$?" $LINENO

file="$php_executable"
link="$parentdir/php-7.4"

if [ -f $link ]; then
	rm $link
	fn_stoponerror "$?" $LINENO
fi

ln -s $file $link
fn_stoponerror "$?" $LINENO

chmod u+x $link
fn_stoponerror "$?" $LINENO

$link --version
fn_stoponerror "$?" $LINENO
