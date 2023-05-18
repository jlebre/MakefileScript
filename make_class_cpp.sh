#!/bin/bash

#Script to create .hh and .cpp

DIR=${PWD##*/}

NB_ARGS=$#

if [[ "$NB_ARGS" -ne "1" ]];
then
	echo "Wrong Number of arguments!"
	exit 1
fi

NAME="$1";
TEMP="${NAME,,}";
CLASS="${TEMP^}";

SUF_CPP=".cpp"
SUF_HPP=".hpp"

FILE_CPP="$CLASS$SUF_CPP"
FILE_HPP="$CLASS$SUF_HPP"

success()
{
	echo -e '\033[0;32m' 
	echo "$1 sucessfully created!"
	echo -e '\033[0m'
}

create_new()
{
	if [[ $1 == "hpp" ]];
	then
		touch $FILE_HPP
		echo "#ifndef ($FILE_HPP^^)" >> $FILE_HPP
		echo "# define ($FILE_HPP^^)" >> $FILE_HPP
		echo >> $FILE_HPP
		echo "# include <iostream>" >> $FILE_HPP
		echo >> $FILE_HPP
		echo "class $CLASS">> $FILE_HPP
		echo "{" >> $FILE_HPP
		echo "	private":>> $FILE_HPP
		echo >> $FILE_HPP
		echo "	public:" >> $FILE_HPP
		echo "		$CLASS(void);   " >> $FILE_HPP
		echo "		$CLASS(const $CLASS& copy);  " >> $FILE_HPP
		echo "		~$CLASS();" >> $FILE_HPP
		echo "		$CLASS& operator = ( const $CLASS&);" >> $FILE_HPP
		echo "};" >> $FILE_HPP
		echo >> $FILE_HPP
		echo "#endif" >> $FILE_HPP
		echo >> $FILE_HPP
	elif [[ $1 == "cpp" ]];
	then
		touch $FILE_CPP
		echo "#include \"$FILE_HPP\"" >> $FILE_CPP
		echo >> $FILE_CPP
		echo "$CLASS::$CLASS(){}" >> $FILE_CPP
		echo >> $FILE_CPP
		echo "$CLASS::$CLASS( const $CLASS &copy ){ ( void )copy; }" >> $FILE_CPP
		echo >> $FILE_CPP
		echo "$CLASS &$CLASS::operator=(const $CLASS &copy){ ( void )copy; }" >> $FILE_CPP
		echo >> $FILE_CPP
		echo "$CLASS::~$CLASS(){}" >> $FILE_CPP
		echo >> $FILE_CPP
	else
		echo -e '\033[0;31mError: Creating New Files!\033[0m'
	fi
}

check_exists()
{
	if [[ -e $1 ]];
	then
		echo "$1 already exists!"
		echo "Do you want to overwrite it? (y/n): "
		read -r ans
		if [[ "$ans" == "y" ]];
		then
			rm -rf $1
			create_new ${1##*.}
			success $1
		else
			exit 1
		fi
	else			
		create_new ${1##*.}
		success $1
	fi
}

check_exists $FILE_HPP
check_exists $FILE_CPP

##############
# by: jlebre #                      
#####################################
# Github: https://github.com/jlebre #
#####################################
