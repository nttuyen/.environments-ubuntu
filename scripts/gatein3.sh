#!/bin/bash
#Before run
 
#DEFINE
if [ "$GATEIN_HOME" == "" ] ; then
  GATEIN_HOME=$GATEIN_DEFAULT_HOME
fi
cd $GATEIN_HOME;
 
#maven build profile
GATEIN_MAVEN_SERVER_PROFILE_TOMCAT="-Dservers.dir=/home/tuyennt/java/servers -Dgatein.dev=tomcat7 -Ddownload"
GATEIN_MAVEN_SERVER_PROFILE_JBOSS="-Dservers.dir=/home/tuyennt/java/servers -Dgatein.dev=jbossas711 -Ddownload"
GATEIN_MAVEN_SERVER_PROFILE_JBOSS_EAP="-Dservers.dir=/home/tuyennt/java/servers -Dgatein.dev=jbosseap6 -Dserver.name=jboss-eap-6.0 -Ddownload"
 
#Server dir
GATEIN_EXECUTE_TOMCAT_DIR=$GATEIN_HOME/packaging/tomcat/tomcat7/target/tomcat
GATEIN_EXECUTE_JBOSS_DIR=$GATEIN_HOME/packaging/jboss-as7/pkg/target/jboss
 
 
GATEIN_MAVEN_SERVER_PROFILE=$GATEIN_MAVEN_SERVER_PROFILE_TOMCAT
GATEIN_EXECUTE_DIR=$GATEIN_EXECUTE_TOMCAT_DIR
 
# ================ MAVEN ====================
MAVEN_PARAMS=""
maven_prepair_params(){
  SERVER_TYPE="tomcat"
  for param in "$@"
  do
    case $param in
      -Djboss)
      
        #Maven params
        SERVER_TYPE="jboss"
        MAVEN_PARAMS="$MAVEN_PARAMS $GATEIN_MAVEN_SERVER_PROFILE_JBOSS"
        ;;
      *)
        MAVEN_PARAMS="$MAVEN_PARAMS $param"
        ;;
    esac;
  done;
  
  if [ "$SERVER_TYPE" == "tomcat" ] ; then
    MAVEN_PARAMS="$MAVEN_PARAMS $GATEIN_MAVEN_SERVER_PROFILE_TOMCAT"
  fi
  
}
 
maven() {
	maven_prepair_params $@
	echo "COMMAND: mvn $MAVEN_PARAMS";
	mvn $MAVEN_PARAMS
}
# ================ END MAVEN ====================
 
# ================ RUN ====================
SERVER_DIR=$GATEIN_EXECUTE_TOMCAT_DIR
SERVER_TYPE="tomcat"
run_prepair_params() {
  for param in "$@"
  do
    case $param in
      -Djboss)
      
        #Maven params
        SERVER_DIR=$GATEIN_EXECUTE_JBOSS_DIR
        SERVER_TYPE="jboss"
        ;;
      *)
        #Do nothing here
        ;;
    esac;
  done;
}
run(){
  run_prepair_params $@
  
  if [ -d $SERVER_DIR ]; then
    cd $SERVER_DIR/bin
    
    if [ "$SERVER_TYPE" == "jboss" ] ; then
      #JBOSS SERVER
      #Append to file is duplicate
      LAST_LINE=`cat $GATEIN_SERVER_DIR/bin/standalone.conf | tail -1`
      echo $LAST_LINE
      if [ "$LAST_LINE" != "#APPEND_OK" ]; then
        echo "JAVA_OPTS=\"\$JAVA_OPTS -Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xms1536m -Xmx1536m -XX:NewSize=256m -XX:MaxNewSize=256m -XX:PermSize=256m -XX:MaxPermSize=256m -XX:+DisableExplicitGC\"" >> $GATEIN_SERVER_DIR/bin/standalone.conf
    		echo "JAVA_OPTS=\"\$JAVA_OPTS -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n\"" >> $GATEIN_SERVER_DIR/bin/standalone.conf
				echo "JAVA_OPTS=\"\$JAVA_OPTS -javaagent:/home/tuyennt/java/environments/jrebel/jrebel.jar -Drebel.remoting_plugin=true \"" >> $GATEIN_SERVER_DIR/bin/standalone.conf
    		echo "#APPEND_OK" >> $GATEIN_SERVER_DIR/bin/standalone.conf
      fi
      
      #RUN JBOSS SERVER
      echo "NEED TO EXECUTE JBOSS SERVER"
      
    else
      #Run tomcat
      #This code block is copy from gatein-dev.sh
      LOG_OPTS="-Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog"
      SECURITY_OPTS="-Djava.security.auth.login.config=../conf/jaas.conf"
      EXO_OPTS="-Dexo.product.developing=true -Dexo.conf.dir.name=gatein/conf -Djava.awt.headless=true"
      EXO_CONFIG_OPTS="-Xms128m -Xmx512m -XX:MaxPermSize=256m -Dorg.exoplatform.container.configuration.debug"
      JPDA_TRANSPORT=dt_socket
      JPDA_ADDRESS=8000
      REMOTE_DEBUG="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"
      JMX_AGENT="-Dcom.sun.management.jmxremote"
      GATEIN_OPTS="-javaagent:/home/tuyennt/java/environments/jrebel/jrebel.jar -Drebel.remoting_plugin=true"
      
      while getopts "D:" OPTION
      do
           case $OPTION in
               D)
                   GATEIN_OPTS="$GATEIN_OPTS -D$OPTARG"
                   ;;
           esac
      done
 
      # skip getopt parms
      shift $((OPTIND-1))
 
      JAVA_OPTS="$JAVA_OPTS $LOG_OPTS $SECURITY_OPTS $EXO_OPTS $EXO_CONFIG_OPTS $REMOTE_DEBUG $GATEIN_OPTS"
      export JAVA_OPTS
 
      # Launches the server
      ./catalina.sh "run"
    fi
    
	else
		echo "You need build it with $SERVER_TYPE server before run";
	fi
}
# ================ END RUN ====================
 
#TODO: DEPLOYMENT
deploy() {
  if [ -d $GATEIN_SERVER_DIR ]; then
    for var in "$@"
	  do
		  case $var in
			  *.jar)
			    cp -r $var $GATEIN_SERVER_JAR/
				  ;;
				*.war)
          cp -r $var $GATEIN_SERVER_WAR/
				  ;;
				*.ear)
				  echo $GATEIN_SERVER_EAR;
				  cp -r $var $GATEIN_SERVER_EAR/
				  ;;
			  *)
			    echo "Can not automatic deploy file: $var"
			    ;;
		  esac;
	  done;
	else
		echo "You need build it before deploy anything";
	fi
}
 
#TODO: clean data
clean_data() {
  echo $GATEIN_SERVER_DATA_DIR
  if [ -d $GATEIN_SERVER_DATA_DIR ]; then
    rm -rf $GATEIN_SERVER_DATA_DIR
  fi
}
 
 
case $1 in
	run)
	  echo "Execute run"
		run $@
		;;
	deploy)
	  shift 1
	  deploy $@;
	  ;;
	clean-data)
	  clean_data
	  ;;
	*)
		maven $@;
		;;
esac
