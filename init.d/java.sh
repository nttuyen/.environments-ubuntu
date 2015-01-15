#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi
 
function setup_jdk() {
  #Process JAVA with JDK
  DEFAULT_VERSION=7
  DEFAULT_HOME="$ENVIRONMENT_DIR/jdk"
 
  #Process old version of jdk
  #Remove all old PATH and OLD folder
  OLD_HOME=$JAVA_HOME
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
 
  # Process JAVA_HOME directory
  JAVA_HOME="$ENVIRONMENT_DIR/jdk$VERSION"
  if [ ! -d "$JAVA_HOME" ] ; then
    echo "JAVA_HOME directory is not exist: $JAVA_HOME"
    echo "Use default JAVA_HOME directory: $DEFAULT_HOME"
    JAVA_HOME=$DEFAULT_HOME
  fi
 
  if [ ! -d "$JAVA_HOME"  ] ; then
    echo "JAVA_HOME directory is not exist: $JAVA_HOME"
    return 0
  fi
 
  export JAVA_HOME
  export PATH=$JAVA_HOME/bin:$PATH
 
  #echo "Current JAVA_HOME: $JAVA_HOME"
  return 1
}
