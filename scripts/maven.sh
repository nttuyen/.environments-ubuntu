#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi
 
setup_maven() {
  #Process MAVEN with JDK
  DEFAULT_VERSION=3
  DEFAULT_HOME="$ENVIRONMENT_DIR/maven"
 
  #Process old version of jdk
  #Remove all old PATH and OLD folder
  OLD_HOME=$MAVEN_HOME
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
  #echo "Switch to use maven version $VERSION"
 
  # Process MAVEN_HOME directory
  MAVEN_HOME="$ENVIRONMENT_DIR/maven$VERSION"
  if [ ! -d "$MAVEN_HOME" ] ; then
    echo "MAVEN_HOME directory is not exist: $MAVEN_HOME"
    echo "Use default MAVEN_HOME directory: $DEFAULT_HOME"
    MAVEN_HOME=$DEFAULT_HOME
  fi
 
  if [ ! -d "$MAVEN_HOME"  ] ; then
    echo "MAVEN_HOME directory is not exist: $MAVEN_HOME"
    return 0
  fi
 
  export MAVEN_HOME
  export PATH=$MAVEN_HOME/bin:$PATH
 
  echo "Current MAVEN_HOME: $MAVEN_HOME"
  return 1
}

