#!/bin/bash

current_directory=$PWD
url="https://ftp.postgresql.org/pub/source/v11.4/postgresql-11.4.tar.gz"     
File_name="postgresql-11.4.tar.gz"                                          
Default_port=5432                                                           
Default_install_path=$PWD                                                   
Default_build_path=$PWD
Custom_conf_file="$current_directory/custom.conf"

declare -A props

file="./datas.properties"

while IFS='=' read -r key value; do

    if [[ $key == "install_path" ]]
    then
        install_path="$value"
    elif [[ $key == "build_path" ]]
    then 
        build_path="$value"
    elif [[ $key == "port" ]]
    then
        port=$value
    fi

done < "$file"

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

# curl ${url} --output $install_path/$File_name

# cd $install_path

# tar -xf postgresql-11.4.tar.gz

# cd postgresql-11.4

# ./configure --prefix=$install_path/pg11 --without-readline --without-zlib

# make

# make install

# sudo mkdir $build_path

# sudo chown $USER $build_path

# cd $install_path/pg11/bin

# ./initdb -D $build_path

postgresql_conf_file=$build_path/postgresql.conf

while IFS=' = ' read -r key value
do
    if grep -q "$key = " "$postgresql_conf_file";then
        export oldValue=$(grep "$key = " "$postgresql_conf_file" | cut -d'=' -f2)
        sed -i "s/$oldValue/"$value"/g" "$postgresql_conf_file"        
    else
        echo "Not found $key"
        echo "$key = $value" >> "$postgresql_conf_file"
    fi
done < "$Custom_conf_file"

# echo port = $port >> $current_directory/custom.conf

# cat $current_directory/custom.conf >> $build_path/postgresql.conf

printf "\n*************************************************************************************************\n"

# ./pg_ctl -D ../data -o "-F -p $port" start

# psql postgres -p $port -h localhost
