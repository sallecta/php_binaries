#!/usr/bin/env bash

#usage:
# fn_stoponerror "$?" $LINENO
fn_stoponerror () {
lNo=$(expr $2 - 1)
if [ $1 -ne 0 ]; then
        printf '%s\n\n' "$lNo: error [$1]"
        exit $1
else
       printf '%s\n' "$lNo success"
fi
}

dir0="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dirPhpRoot="$dir0/php-7.4.13_build"
dirWww="$dir0/www_root"
serverPort=8080


if [ "$1" = "run" ]; then 

    cd $dirPhpRoot
    fn_stoponerror "$?" $LINENO

    ls $dirWww > /dev/null
    fn_stoponerror "$?" $LINENO 

    bin/php -S localhost:$serverPort -t $dirWww
    fn_stoponerror "$?" $LINENO

else

    printf '\n%s\n' "This script runs portable php server. Usage:
    1) set the dirPhpRoot to your portable php binaries. ex. $dir0/php-7.4.13_build;
    2) set the dirWww to yor www root directory, ex.'$dir0/www_root';
    3) set the serverPort variable, ex 8080;
    3) launch this script with 'run' argument.
    "

fi
