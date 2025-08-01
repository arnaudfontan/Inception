#!/bin/bash


    mysqld_safe &
    
    sleep 5
    

    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';"
    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -e "FLUSH PRIVILEGES;"

    mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    killall mysqld_safe
    wait

    exec mysqld_safe