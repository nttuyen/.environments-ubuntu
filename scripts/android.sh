#!/bin/bash
if [ "$ENVIRONMENT_DIR" == "" ] ; then
  ENVIRONMENT_DIR=~/.environments
fi

export ANDROID_SDK_HOME=$ENVIRONMENT_DIR/android_sdk


function adb(){
	ADB_PATH=$ANDROID_SDK_HOME/platform-tools/adb
	
	sudo $ADB_PATH $@
}
