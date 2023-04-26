#!/bin/bash

DIR=${PWD##*/}

NB_ARGS=$#


if [[ "$NB_ARGS" -gt "1" ]];
then
    echo "Too many arguments!"
    exit 1
fi

if [[ "$NB_ARGS" == "1" ]];
then
    NAME="$1";
else
    NAME="$DIR";
fi

create_makefile()
{
    touch Makefile
    echo "CC = g++" >> Makefile
    echo "RM = rm -f" >> Makefile
    echo "CPPFLAGS = -Wall -Wextra -Werror -std=c++98" >> Makefile
    echo "NAME =" $NAME >> Makefile
    echo "SRC = main.cpp" >> Makefile
    echo >> Makefile
    echo  'all: $(NAME)' >> Makefile
    echo >> Makefile
    echo '$(NAME):' >> Makefile
    echo -e "\t"@'$(CC)' '$(CPPFLAGS)' '$(SRC)' -o '$(NAME)' >> Makefile
    echo >> Makefile
    echo clean: >> Makefile
    echo >> Makefile
    echo fclean: >> Makefile
    echo -e '\t@$(RM) $(NAME)' >> Makefile
    echo -e '\techo "'$NAME 'Removed!"' >> Makefile
    echo >> Makefile
    echo a: >> Makefile
    echo -e "\t@make fclean" >> Makefile
    echo -e "\t@make" >> Makefile
    echo -e "\t@./$NAME" >> Makefile
    echo >> Makefile
    echo .PHONY: all clean fclean a >> Makefile
}

if [[ -e Makefile ]];
then
    echo "Makefile already exists!"
    echo "Do you want to overwrite it? (y/n): "
    read -r ans
    if [[ "$ans" == "y" ]];
    then
        rm -rf Makefile
        create_makefile
    else
        exit 1
    fi
else
    create_makefile
fi
