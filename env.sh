#!/bin/bash
ENV_DIR=~/.environments
ENV_HOME=$ENV_DIR
export ENVS_HOME=$ENV_DIR/envs
export ENVIRONMENT_DIR=$ENV_HOME
export ENVIRONMENT_INIT_SCRIPT_DIR=$ENVIRONMENT_DIR/init.d
export ENVIRONMENT_SCRIPT_DIR=$ENVIRONMENT_DIR/scripts
 
if [ -d "$ENVIRONMENT_DIR/bin" ] ; then
  export PATH=$ENVIRONMENT_DIR/bin:$PATH
fi

# Load all script file in 
for file in $ENVIRONMENT_INIT_SCRIPT_DIR/*
do
  . $file
done

# Setup something
setup_jdk
setup_maven
setup_gradle

