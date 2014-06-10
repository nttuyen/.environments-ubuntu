#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
  ENVIRONMENT_SCRIPT_DIR=$ENVIRONMENT_DIR/scripts
fi
 
GATEIN3_HOME=$HOME/java/projects/gatein/gatein3
 
 
gtn_cd() {
  case $1 in
    tomcat)
       cd "$GATEIN3_HOME/packaging/tomcat/tomcat7/target/tomcat"
      ;;
    jboss)
      cd "$GATEIN3_HOME/packaging/jboss-as7/pkg/target/jboss"
      ;;
    *)
      cd $GATEIN3_HOME
      ;;
  esac
}
 
gtn() {
 
  case $1 in
    cd)
      gtn_cd $2
      ;;
    *)
      $ENVIRONMENT_SCRIPT_DIR/gatein3.sh $@
      ;;
  esac
}
