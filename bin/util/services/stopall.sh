#!/bin/bash
clear
echo --------------------------------------------------------------------------------
echo Stopping Dropwizard enabled CEDAR microservices
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

shopt -s expand_aliases
source $CEDAR_UTIL_BIN/set-dev-aliases.sh

stopworkspace
stoprepo
stopgroup
stopmessaging
stopresource
stopschema
stoptemplate
stopterminology
stopuser
stopvaluerecommender
stopsubmission
stopworker
stopfairdata