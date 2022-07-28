#!/bin/bash

url="https://ftp.postgresql.org/pub/source/v11.4/postgresql-11.4.tar.gz"     
File_name="postgresql-11.4.tar.gz"                                          
Default_port=5432                                                           
Default_install_path=$PWD                                                   
Default_build_path=$PWD

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

echo $port


curl ${url} --output $install_path/$File_name

cd $install_path

tar -xf postgresql-11.4.tar.gz

cd postgresql-11.4

./configure --prefix=$install_path/pg11 --without-readline --without-zlib -with-pgport-$port

make

make install

sudo mkdir $build_path

sudo chown $USER $build_path

cd $install_path/pg11/bin

./initdb -D $build_path

printf "\n*************************************************************************************************\n"

./pg_ctl -D ../data -o "-F -p $port" start

psql postgres -p $port -h localhost
