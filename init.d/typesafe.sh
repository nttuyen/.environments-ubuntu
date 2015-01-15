#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi
 
function setup_typesafe_activator() {
  DEFAULT_VERSION="1.2.12"
  DEFAULT_HOME="$ENVS_HOME/activator-1.2.12"
 
  #Process old version of scala
  #Remove all old PATH and OLD folder
  OLD_HOME=$TYPESAFE_ACTIVATOR_HOME
  OLD_PATH=$PATH
  
  if [ "$OLD_HOME" != "" ] ; then
    NEW_PATH="${PATH//$OLD_HOME\:/}"
    export PATH=$NEW_PATH
  fi
 
  #Process JDK version from input
  VERSION=$1
  if [ "$VERSION" == "" ] ; then
    VERSION=$DEFAULT_VERSION
  fi
 
  # Process TYPESAFE_ACTIVATOR_HOME directory
  TYPESAFE_ACTIVATOR_HOME="$ENVS_HOME/activator-$VERSION"
  if [ ! -d "$TYPESAFE_ACTIVATOR_HOME" ] ; then
    echo "TYPESAFE_ACTIVATOR_HOME directory is not exist: $TYPESAFE_ACTIVATOR_HOME"
    echo "Use default TYPESAFE_ACTIVATOR_HOME directory: $DEFAULT_HOME"
    TYPESAFE_ACTIVATOR_HOME=$DEFAULT_HOME
  fi
 
  if [ ! -d "$TYPESAFE_ACTIVATOR_HOME"  ] ; then
    echo "TYPESAFE_ACTIVATOR_HOME directory is not exist: $TYPESAFE_ACTIVATOR_HOME"
    return 0
  fi
 
  export TYPESAFE_ACTIVATOR_HOME
  export PATH=$TYPESAFE_ACTIVATOR_HOME:$PATH
 
  #echo "Current TYPESAFE_ACTIVATOR_HOME: $TYPESAFE_ACTIVATOR_HOME"
  return 1
}

#Call setup typesafe_activation
setup_typesafe_activator
