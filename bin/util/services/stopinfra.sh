#!/bin/bash
clear
echo --------------------------------------------------------------------------------
echo Stopping CEDAR infrastructure services
echo --------------------------------------------------------------------------------
echo

$CEDAR_UTIL_BIN/services/bin/killkeycloak.sh
$CEDAR_UTIL_BIN/services/bin/stopmongo.sh
$CEDAR_UTIL_BIN/services/bin/stopelastic.sh
$CEDAR_UTIL_BIN/services/bin/stopkibana.sh
$CEDAR_UTIL_BIN/services/bin/stopneo.sh
$CEDAR_UTIL_BIN/services/bin/killrediscommander.sh
$CEDAR_UTIL_BIN/services/bin/stopredis.sh
$CEDAR_UTIL_BIN/services/bin/stopmysql.sh
$CEDAR_UTIL_BIN/services/bin/stopnginx.sh
