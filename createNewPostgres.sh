#!/bin/bash

# IFS=","

url="https://ftp.postgresql.org/pub/source/v11.4/postgresql-11.4.tar.gz"
File_name="postgresql-11.4.tar.gz"
Default_port=5432
Default_install_path=$PWD
Default_build_path=$PWD/pg11/

read -ra arr <<< "$@"

for var in ${arr[@]};do 
    if [[ $var == *"install_path"* ]]
    then
        install_path=$(echo $var| cut -d'=' -f 2)
    elif [[ $var == *"build_path"* ]]
    then 
        build_path=$(echo $var| cut -d'=' -f 2)
    elif [[ $var == *"port"* ]]
    then
        port=$(echo $var| cut -d'=' -f 2)
    fi
done

# InstallPathFunction

if [ -z "$install_path" ]
then
    install_path=$Default_install_path
fi

# BuildPathFunction

if [ -z "$build_path" ]
then
    build_path=$Default_build_path
fi


# PortFunction

if [ -z "$port" ]
then
    port=$Default_port
fi

#########################################

curl ${url} --output $install_path/$File_name

cd $install_path

tar -xf postgresql-11.4.tar.gz

cd postgresql-11.4

./configure --prefix=$build_path --without-readline --without-zlib

make

make install

sudo mkdir $build_path/data

sudo chown muguntha-pt5620 $build_path/data

cd $build_path/bin

./initdb -D ../data

# printf "\n*************************************************************************************************\n"

./pg_ctl -D ../data -o "-F -p $port" start

# psql postgres -p $port -h localhost

# # cd /home/local/ZOHOCORP/muguntha-pt5620/Desktop/TASK_01/pg11/bin && ./pg_ctl -D  /home/local/ZOHOCORP/muguntha-pt5620/Desktop/TASK_01/pg11/bin/../data2 -o "-F -p 5433" stop  $$ cd          --------------> to stop server



