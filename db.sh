#! /bin/bash
sudo apt update
sudo apt install postgresql-client -y
psql postgresql://${login}:${password}@${address}/${dbname} -c "CREATE TABLE cities (name varchar(80));"