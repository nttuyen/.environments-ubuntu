#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
  ENVIRONMENT_SCRIPT_DIR=$ENVIRONMENT_DIR/scripts
fi

export GATEIN_DEFAULT_HOME=$HOME/projects/exo/gatein/gatein-portal/master
export GATEIN_35_HOME=$HOME/projects/exo/gatein/gatein-portal/3.5
export GATEIN_36_HOME=$HOME/projects/exo/gatein/gatein-portal/3.6
export GATEIN_37_HOME=$HOME/projects/exo/gatein/gatein-portal/3.7
export GATEIN_EXO_35_HOME=$HOME/projects/exo/gatein/exogtn/3.5.x
export GATEIN_EXO_37_HOME=$HOME/projects/exo/gatein/exogtn/3.7.x

#export GATEIN_HOME=GATEIN_DEFAULT_HOME
#export GATEIN_VERSION=3

gtn_switch_version() {
	case $1 in 
	  3.5)
	    GATEIN_HOME=$GATEIN_35_HOME
	    GATEIN_VERSION=3
	    ;;
	  3.6)
	    GATEIN_HOME=$GATEIN_36_HOME
	    GATEIN_VERSION=3
	    ;;
	  3.7)
	    GATEIN_HOME=$GATEIN_37_HOME
	    GATEIN_VERSION=3
	    ;;
	  exogtn35)
	    GATEIN_HOME=$GATEIN_EXO_35_HOME
	    GATEIN_VERSION=3
	    ;;
	  exogtn37)
	    GATEIN_HOME=$GATEIN_EXO_37_HOME
	    GATEIN_VERSION=3
	    ;;
	  #master)
	  *)
	    GATEIN_HOME=$GATEIN_DEFAULT_HOME
	    GATEIN_VERSION=3
	    ;;
	esac
	
	echo "GATEIN_HOME=$GATEIN_HOME"
	echo "GATEIN_VERSION=$GATEIN_VERSION"
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
    case $1 in
      tomcat)
          echo "This command is not supported in gatein version $GATEIN_VERSION"
        ;;
      jboss)
          echo "This command is not supported in gatein version $GATEIN_VERSION"
        ;;
      *)
          cd $GATEIN_HOME
        ;;
    esac
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
        if [ -f "$ENVIRONMENT_SCRIPT_DIR/gatein$GATEIN_VERSION.sh" ] ; then
          echo "$ENVIRONMENT_SCRIPT_DIR/gatein$GATEIN_VERSION.sh"
          $ENVIRONMENT_SCRIPT_DIR/gatein$GATEIN_VERSION.sh $@
        else
          echo "Script file for gatein version $GATEIN_VERSION is not found"
        fi
      ;;
  esac
}

gtn switch

