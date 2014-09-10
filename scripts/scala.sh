#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi
 
function setup_scala() {
  DEFAULT_VERSION="2.11.2"
  DEFAULT_HOME="$ENVIRONMENT_DIR/scala-2.11.2"
 
  #Process old version of scala
  #Remove all old PATH and OLD folder
  OLD_HOME=$SCALA_HOME
  OLD_PATH=$PATH
  
  if [ "$OLD_HOME" != "" ] ; then
    NEW_PATH="${PATH//$OLD_HOME\/bin:/}"
    export PATH=$NEW_PATH
  fi
 
  #Process JDK version from input
  VERSION=$1
  if [ "$VERSION" == "" ] ; then
    VERSION=$DEFAULT_VERSION
  fi
 
  # Process SCALA_HOME directory
  SCALA_HOME="$ENVIRONMENT_DIR/scala-$VERSION"
  if [ ! -d "$SCALA_HOME" ] ; then
    echo "SCALA_HOME directory is not exist: $SCALA_HOME"
    echo "Use default SCALA_HOME directory: $DEFAULT_HOME"
    SCALA_HOME=$DEFAULT_HOME
  fi
 
  if [ ! -d "$SCALA_HOME"  ] ; then
    echo "SCALA_HOME directory is not exist: $SCALA_HOME"
    return 0
  fi
 
  export SCALA_HOME
  export PATH=$SCALA_HOME/bin:$PATH
 
  echo "Current SCALA_HOME: $SCALA_HOME"
  return 1
}
