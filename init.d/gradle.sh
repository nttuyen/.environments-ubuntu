#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi
 
function setup_gradle() {
  DEFAULT_VERSION="2.1"
  DEFAULT_HOME="$ENVIRONMENT_DIR/gradle-2.1"
 
  #Process old version of gradle
  #Remove all old PATH and OLD folder
  OLD_HOME=$GRADLE_HOME
  OLD_PATH=$PATH
  
  if [ "$OLD_HOME" != "" ] ; then
    NEW_PATH="${PATH//$OLD_HOME\/bin:/}"
    export PATH=$NEW_PATH
  fi
 
  #Process GRADLE version from input
  VERSION=$1
  if [ "$VERSION" == "" ] ; then
    VERSION=$DEFAULT_VERSION
  fi
 
  # Process SCALA_HOME directory
  GRADLE_HOME="$ENVIRONMENT_DIR/gradle-$VERSION"
  if [ ! -d "$GRADLE_HOME" ] ; then
    echo "GRADLE_HOME directory is not exist: $GRADLE_HOME"
    echo "Use default GRADLE_HOME directory: $DEFAULT_HOME"
    GRADLE_HOME=$DEFAULT_HOME
  fi
 
  if [ ! -d "$GRADLE_HOME"  ] ; then
    echo "SGRADLE_HOME directory is not exist: $GRADLE_HOME"
    return 0
  fi
 
  export GRADLE_HOME
  export PATH=$GRADLE_HOME/bin:$PATH
 
  #echo "Current GRADLE_HOME: $GRADLE_HOME"
  return 1
}
