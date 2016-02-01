#!/bin/bash

if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi

APACHE2_TEMPLATE_DIR=$ENVIRONMENT_DIR/templates/apache2
APACHE2_TEMPLATE=$APACHE2_TEMPLATE_DIR/site.conf

APACHE2_HOME=/etc/apache2
APACHE2_SITE_ENABLED=$APACHE2_HOME/sites-enabled

APACHE2_TMP_DIR=/tmp/apache2

function a2create() {
	CURRENT_DIR=$(pwd)

	SITE_NAME_OK=0
	while [ $SITE_NAME_OK -eq 0 ]
	do
		echo -n "Enter the site name: "
		read SITE_NAME

		if [ "$SITE_NAME" == "" ]; then
			echo "Site name is required"
		elif [ -f "$APACHE2_SITE_ENABLED/$SITE_NAME.conf" ]; then
			echo "Site with name $SITE_NAME is already exist, please choose other name."
		else 
			SITE_NAME_OK=1
		fi
	done

	PORT_OK=0
	PORT=80
	while [ $PORT_OK -eq 0 ]
	do
		echo -n "Enter the port: "
		read PORT

		if [ "$PORT" == "" ] || [ "$PORT" == "80" ]; then
			echo "The port $PORT is used. Please use other port"
			PORT_OK=0
		elif ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
			echo "The port must be an integer."
		elif [ $PORT -lt 80 ]; then
			echo "The port must be greater than 80."
		else
			PORT_USED=0
			for f in $APACHE2_SITE_ENABLED/*.conf
			do
			  if grep -Fiq "Listen $PORT" $f ; then
			  	PORT_USED=1
			  fi
			done

			if [ $PORT_USED -eq 1 ]; then
				echo "The port $PORT is used. Please use other port"
			else
				PORT_OK=1
			fi
		fi
	done

	HOME_DIR=""
	HOME_DIR_OK=0
	while [ $HOME_DIR_OK -eq 0 ] 
	do
		echo -n "Enter the site home directory [Default is current directory]: "
		read HOME_DIR

		if [ "$HOME_DIR" == "" ]; then
			HOME_DIR=$CURRENT_DIR
		fi

		if [ -d "$HOME_DIR" ]; then
			HOME_DIR_OK=1
		else
			echo "Directory $HOME_DIR does not exsit."
		fi
	done

	if ! [[ "$HOME_DIR" =~ ^.*\/$ ]]; then
		HOME_DIR="$HOME_DIR/"
	fi

	echo "Site for directory $HOME_DIR_OK will have name: $SITE_NAME and port $PORT"

	mkdir -p $APACHE2_TMP_DIR
	sudo chmod 777 $APACHE2_TMP_DIR

	cat $APACHE2_TEMPLATE | sed "s|__PORT__|$PORT|g" | sed "s|__HOME_DIR__|$HOME_DIR|g" | sed "s|__SITE__|$SITE_NAME|g" > $APACHE2_TMP_DIR/$SITE_NAME.conf
	sudo mv $APACHE2_TMP_DIR/$SITE_NAME.conf $APACHE2_SITE_ENABLED/$SITE_NAME.conf

	if [ -f "$APACHE2_SITE_ENABLED/$SITE_NAME.conf" ]; then
		echo "Create file successfully"
		sudo chown root:root $APACHE2_SITE_ENABLED/$SITE_NAME.conf
		sudo chmod 644 $APACHE2_SITE_ENABLED/$SITE_NAME.conf
		sudo service apache2 restart
	else
		echo "Can not create conf file"
	fi
}

function a2delete() {
	SITE_NAME=$1
	SITE_NAME_OK=0

	if [ "$SITE_NAME" == "" ]; then
		echo "Use command: a2delete [SITE_NAME]"
		return 1;
	fi
	
	if [ -f "$APACHE2_SITE_ENABLED/$SITE_NAME.conf" ]; then
		sudo rm $APACHE2_SITE_ENABLED/$SITE_NAME.conf
		if [ -f "$APACHE2_SITE_ENABLED/$SITE_NAME.conf" ]; then
			echo "Can not remove site, please try again.";
		else
			echo "Remove site successfully" 
		fi
	else 
		echo "Site $SITE_NAME does not exist"
	fi
}