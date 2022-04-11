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

phprelease=php-7.4.13
phpSrcDir="$dir0/src"
phpInstallDir="$dir0/install/$phprelease"_build""


printf '\n%s\n' "Checking root directory"
cd $dir0
fn_stoponerror "$?" $LINENO

if [ "$1" = "clean" ]; then 
    printf '\n%s\n' "Removing src and install directories"
    rm -r  "$dir0/src"   "$dir0/install"
    fn_stoponerror "$?" $LINENO

elif [ "$1" = "make" ]; then 
    printf '\n%s\n' "Creating php source directory [$phpSrcDir]"
    mkdir -p "$phpSrcDir"
    fn_stoponerror "$?" $LINENO

    printf '\n%s\n' "Extracting php source [$phprelease]"
    tar -xf "$dir0/distr/"$phprelease".tar.gz" -C "$phpSrcDir"
    fn_stoponerror "$?" $LINENO

    printf '\n%s\n' "Creating installation directory [$phpInstallDir]"
    mkdir -p $phpInstallDir
    fn_stoponerror "$?" $LINENO

    printf '\n%s\n' "Entering php source directory [$phprelease]"
    cd "$phpSrcDir/"$phprelease
    fn_stoponerror "$?" $LINENO

    printf '\n%s\n' "Configuring $phprelease"
    ./configure --prefix=$phpInstallDir
    fn_stoponerror "$?" $LINENO

    printf '\n%s\n' "Making $phprelease"
    make SHELL='sh -x'  > $dir0/make_log.txt 2>&1
    fn_stoponerror "$?" $LINENO

    printf '\n%s\n' "Installing silently $phprelease to [$phpInstallDir]"
    make install > /dev/null
    fn_stoponerror "$?" $LINENO

elif  [ "$1" = "pack" ]; then 
    printf '\n%s\n' "Packing [$phpInstallDir] to ["$dir0/$phprelease"_build".tar.gz"]"
    cd "$dir0/install"
    fn_stoponerror "$?" $LINENO

    tar -czf "$dir0/$phprelease"_build".tar.gz" "$phprelease"_build""
    fn_stoponerror "$?" $LINENO
else
    printf '\n%s\n' "Wrong argument [$1]. Use:
    clean - to delete builded and installed files;
    make  - to configure, make and install (create portable) $phprelease;
    pack  - to pack portable $phprelease build in tar.gz"
fi



printf '\n%s\n' "Finished [$LINENO]"
