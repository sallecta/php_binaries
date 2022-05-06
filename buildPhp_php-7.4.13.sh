#!/usr/bin/env bash

fn_stoponerror ()
{
	# Usage:
	# fn_stoponerror $? $LINENO
	error_code=$1
	line=$2
	if [ $error_code -ne 0 ]; then
		printf "\n"$line": error ["$error_code"]\n\n"
		exit $error_code
	else
		printf "\n"$line": succsess\n\n"
	fi
}

dir0="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

arg_1=$1
arg_2=$2
if [ "$arg_2" = "32" ]; then 
	php_architecture="i686-linux-gnu"

elif [ "$arg_2" = "64" ]; then
	php_architecture="x86_64-linux-gnu"
fi

php_src_name="php-7.4.13"
php_src_dir="$dir0/src"
php_release_name="$php_src_name""_$php_architecture""_build"
php_install_dir="$dir0/install"
php_release_install_dir="$php_install_dir/$php_release_name"
php_tar_archive_name="$php_release_name"".tar.gz"


fn_print_usage ()
{
    printf "
Usage:
	clean	- delete all builded and installed files;
	make 32	- configure, make and install (portable) 32 bit $php_src_name;
	make 64	- configure, make and install (portable) 64 bit $php_src_name;
	pack 32	- pack 32 bit portable in tar.gz;
	pack 64	- pack 64 bit portable in tar.gz.	
\n\n"
}

action=""

if [ "$arg_1" = "clean" ] && [ "$arg_2" = "" ]; then
	action="clean"
	
elif [ "$arg_1" = "make" ] && [ "$arg_2" = "32" ]; then 
	 action="make32"
	php_architecture="i686-linux-gnu"
	
elif [ "$arg_1" = "make" ] &&  [ "$arg_2" = "64" ]; then
	action="make64"
	php_architecture="x86_64-linux-gnu"
	
elif [ "$arg_1" = "pack" ] && [ "$arg_2" = "32" ]; then 
	action="pack"
	php_architecture="i686-linux-gnu"
	
elif [ "$arg_1" = "pack" ] && [ "$arg_2" = "64" ]; then 
	action="pack"
	php_architecture="x86_64-linux-gnu"
	
else
	printf "\n\nWrong arguments: ["$arg_1"], ["$arg_2"].\n\n"
	fn_print_usage
	exit 1
fi

printf "\n"$LINENO": Checking root directory\n"
cd $dir0
fn_stoponerror $? $LINENO

if [ "$action" = "clean" ]; then
	printf "\n"$LINENO": Checkingand install directories\n"
	ls "$php_src_dir"   "$php_install_dir"
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Removing src and install directories\n"
	rm -r  "$php_src_dir"   "$php_install_dir"
	fn_stoponerror $? $LINENO
	
elif [ "$action" = "make32" ]; then
	printf "\n"$LINENO": Creating php source directory [$php_src_dir]\n"
	mkdir -p "$php_src_dir"
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Extracting php source [$php_src_name]\n"
	tar -xf "$dir0/distr/"$php_src_name".tar.gz" -C "$php_src_dir"
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Creating installation directory [$php_release_install_dir]\n"
	mkdir -p $php_release_install_dir
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Entering php source directory [$php_src_name]\n"
	cd "$php_src_dir/"$php_src_name
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Configuring $php_release_name\n"
	./configure --with-mysqli --with-openssl --enable-mbstring --prefix=$php_release_install_dir --host="$php_architecture" CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Making $php_release_name\n"
	old_CFLAGS=$CFLAGS
	old_CXXFLAGS=$CXXFLAGS
	old_LDFLAGS=$LDFLAGS
	export CFLAGS='-m32'
	export CXXFLAGS='-m32'
	export LDFLAGS='-m32'
	make
	ercode=$?
	export CFLAGS=$old_CFLAGS
	export CXXFLAGS=$old_CXXFLAGS
	export LDFLAGS=$old_LDFLAGS
	fn_stoponerror $ercode $LINENO
	
	printf "\n"$LINENO": Installing $php_release_name to [$php_release_install_dir]\n"
	make install
	fn_stoponerror $? $LINENO
	
elif [ "$action" = "make64" ]; then 
	printf "\n"$LINENO": Creating php source directory [$php_src_dir]\n"
	mkdir -p "$php_src_dir"
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Extracting php source [$php_src_name]\n"
	tar -xf "$dir0/distr/"$php_src_name".tar.gz" -C "$php_src_dir"
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Creating installation directory [$php_release_install_dir]\n"
	mkdir -p $php_release_install_dir
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Entering php source directory [$php_src_name]\n"
	cd "$php_src_dir/"$php_src_name
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Configuring $php_release_name\n"
	./configure --with-mysqli --with-openssl --enable-mbstring --prefix=$php_release_install_dir
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Making $php_release_name\n"
	make
	fn_stoponerror $? $LINENO
	
	printf "\n"$LINENO": Installing $php_release_name to [$php_release_install_dir]\n"
	make install
	fn_stoponerror $? $LINENO
	
elif  [ "$action" = "pack" ]; then 
	printf "\n"$LINENO": Packing ["$php_release_install_dir"] to ["$php_tar_archive_name"]\n"
	cd $php_install_dir
	fn_stoponerror $? $LINENO
	
	ls "$php_release_install_dir"
	fn_stoponerror $? $LINENO	
	
	ls "$php_release_name"
	fn_stoponerror $? $LINENO
	
	tar -czf "$dir0/$php_tar_archive_name" "$php_release_name"
	fn_stoponerror $? $LINENO
	
	ls "$dir0/$php_tar_archive_name"
	fn_stoponerror $? $LINENO
	
else
	printf "\n\nUnknown action: ["$action"] (arguments: ["$1"], ["$2"] ).\n\n"
	fn_print_usage
fi



printf "\n"$LINENO": End Of File\n"
