#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
     ENVIRONMENT_DIR=~/.environments
fi

function backup_mysql() {
	mysqldump -h $1 -u $2 -p$3 --skip-extended-insert $4 | gzip > $4.gz	
}

