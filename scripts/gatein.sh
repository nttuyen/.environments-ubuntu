#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
  ENVIRONMENT_SCRIPT_DIR=$ENVIRONMENT_DIR/scripts
fi


GATEIN_HOME=$HOME/java/projects/gatein/gatein3
GATEIN_VERSION=3

gtn_switch_version() {
	case $1 in 
	  3.5)
	    GATEIN_HOME=$HOME/java/project/gatein/gatein/3.5
	    GATEIN_VERSION=3
	    ;;
	  3.6)
	    GATEIN_HOME=$HOME/java/project/gatein/gatein/3.5
	    GATEIN_VERSION=3
	    ;;
	  3.7)
	    GATEIN_HOME=$HOME/java/project/gatein/gatein/3.5
	    GATEIN_VERSION=3
	    ;;
	  master)
	  *)
	    GATEIN_HOME=$HOME/java/project/gatein/gatein/master
	    GATEIN_VERSION=3
	    ;;
	esac
	
	export GATEIN_HOME
	export GATEIN_VERSION
}

 
gtn_cd() {
  if [ "$GATEIN_VERSION" -eq "3" ] ; then
    case $1 in
      tomcat)
          cd "$GATEIN_HOME/packaging/tomcat/tomcat7/target/tomcat"
        ;;
      jboss)
          cd "$GATEIN_HOME/packaging/jboss-as7/pkg/target/jboss"
        ;;
      *)
          cd $GATEIN_HOME
        ;;
    esac
  else
    tomcat)
          echo "This command is not support for gatein version $GATEIN_VERSION"
        ;;
      jboss)
          echo "This command is not support for gatein version $GATEIN_VERSION"
        ;;
      *)
          cd $GATEIN_HOME
        ;;
  fi
}
 
gtn() {
  case $1 in
    cd)
        gtn_cd $2
      ;;
    switch)
        gtn_switch_version $2
      ;;
    *)
        if[ -f "$ENVIRONMENT_SCRIPT_DIR/gatein_$GATEIN_VERSION.sh" ]; then
          $ENVIRONMENT_SCRIPT_DIR/gatein_$GATEIN_VERSION.sh $@
        else
          echo "Script file for gatein version $GATEIN_VERSION is not found"
        fi
      ;;
  esac
}
