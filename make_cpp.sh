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

check_srcs()
{
    if [[ ! -d "srcs" ]]
    then
        mkdir srcs
    fi
    if [[ -e *.cpp ]]
    then
        mv *.cpp ./srcs
    fi
    echo 'FILE_NAME = \' >> Makefile
    for entry in "./srcs"/*cpp
    do
        echo -e '\t\t\t'${entry##*/}' \' >> Makefile
    done
    # Add All files inside the folder
    echo >> Makefile
    echo 'SRCS_DIR = srcs' >> Makefile 
    echo >> Makefile
    echo 'SRCS = $(addprefix $(SRCS_DIR)/, $(FILE_NAME))' >> Makefile
    echo >> Makefile
    echo 'OBJS = $(subst $(SRCS_DIR), $(OBJS_DIR), $(SRCS:.cpp=.o))' >> Makefile
    echo >> Makefile
    echo 'OBJS_DIR = objs' >> Makefile
}

check_includes()
{
    if [[ -e *.hpp ]]
    then
        if [ ! -d "includes" ]
        then
            mkdir includes
        fi
        mv *.hpp ./includes
    fi
}

create_makefile()
{
    check_srcs
    check_includes
    touch Makefile
    echo "CC = g++" >> Makefile
    echo >> Makefile
    echo "RM = rm -f" >> Makefile
    echo >> Makefile
    echo "CPPFLAGS = -Wall -Wextra -Werror -std=c++98" >> Makefile
    echo >> Makefile
    echo "NAME =" $NAME >> Makefile
    echo >> Makefile
    echo  'all: $(NAME)' >> Makefile
    echo >> Makefile
    echo '$(OBJS_DIR)/%.o :	$(SRCS_DIR)/%.cpp' >> Makefile
    echo -e '\t@mkdir -p $(@D)' >> Makefile
    echo -e '\t@$(CC) $(CPPFLAGS) -O3 -c $< -o $@' >> Makefile
    echo >> Makefile
    echo '$(NAME):' >> Makefile
    echo -e "\t"@'$(CC)' '$(CPPFLAGS)' '$(SRC)' -o '$(NAME)' >> Makefile
    echo -e '\techo -e '"'"$NAME 'Compiled!'"'" >> Makefile
    echo >> Makefile
    echo clean: >> Makefile
    echo -e '\t@$(RM) $(OBJS_DIR)' >> Makefile
    echo >> Makefile
    echo fclean: clean >> Makefile
    echo -e '\t@$(RM) $(NAME)' >> Makefile
    echo -e '\techo -e '"'"$NAME 'Removed!'"'" >> Makefile
    echo >> Makefile
    echo re: >> Makefile
    echo -e '\t@make fclean' >> Makefile
    echo -e '\t@make' >> Makefile
    echo >> Makefile
    echo a: >> Makefile
    echo -e "\t@make re" >> Makefile
    echo -e "\t@make clean" >> Makefile
    echo -e "\t@./$NAME" >> Makefile
    echo >> Makefile
    echo .PHONY: all clean fclean re a >> Makefile
}

success()
{
    echo -e '\033[0;32mMakefile sucessfully created!\033[0m'
    exit 0
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
        success
    else
        exit 1
    fi
else
    create_makefile
    success
fi

##############
# by: jlebre #                      
#####################################
# Github: https://github.com/jlebre #
#####################################