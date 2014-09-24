#!/bin/bash
ENV_DIR=~/.environments
ENV_HOME=$ENV_DIR
export ENVIRONMENT_DIR=$ENV_HOME
export ENVIRONMENT_SCRIPT_DIR=$ENVIRONMENT_DIR/scripts
 
if [ -d "$ENVIRONMENT_DIR/bin" ] ; then
  export PATH=$ENVIRONMENT_DIR/bin:$PATH
fi
 
if [ -f "$ENVIRONMENT_DIR/scripts/java.sh" ] ; then
  . $ENVIRONMENT_DIR/scripts/java.sh
  
  setup_jdk
fi
 
if [ -f "$ENVIRONMENT_DIR/scripts/maven.sh" ] ; then
  . $ENVIRONMENT_DIR/scripts/maven.sh
  
  setup_maven
fi
 
if [ -f "$ENVIRONMENT_DIR/scripts/gatein.sh" ] ; then
  . $ENVIRONMENT_DIR/scripts/gatein.sh
fi

if [ -f "$ENVIRONMENT_DIR/scripts/scala.sh" ] ; then
	. $ENVIRONMENT_DIR/scripts/scala.sh
	setup_scala
fi

if [ -f "$ENVIRONMENT_DIR/scripts/gradle.sh" ] ; then
	. $ENVIRONMENT_DIR/scripts/gradle.sh
	setup_gradle
fi


