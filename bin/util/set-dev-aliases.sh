#!/bin/bash

#DEV Util common locations
export CEDAR_UTIL_BIN=${CEDAR_DOCKER_DEPLOY}/bin/util/

#CEDAR location aliases
alias gocedar='cd $CEDAR_HOME'

alias goparent='cd $CEDAR_HOME/cedar-parent'
alias goproject='cd $CEDAR_HOME/cedar-project'

alias goutil='cd $CEDAR_HOME/cedar-util'
alias goconf='cd $CEDAR_HOME/cedar-conf'
alias godocs='cd $CEDAR_HOME/cedar-docs'
alias goservercore='cd $CEDAR_HOME/cedar-server-core-library'
alias gomodel='cd $CEDAR_HOME/cedar-model-validation-library'

alias goadmintool='cd $CEDAR_HOME/cedar-admin-tool'

alias goworkspace='cd $CEDAR_HOME/cedar-workspace-server'
alias gogroup='cd $CEDAR_HOME/cedar-group-server'
alias gomessaging='cd $CEDAR_HOME/cedar-messaging-server'
alias gorepo='cd $CEDAR_HOME/cedar-repo-server'
alias goresource='cd $CEDAR_HOME/cedar-resource-server'
alias goschema='cd $CEDAR_HOME/cedar-schema-server'
alias gotemplate='cd $CEDAR_HOME/cedar-template-server'
alias goterminology='cd $CEDAR_HOME/cedar-terminology-server'
alias gouser='cd $CEDAR_HOME/cedar-user-server'
alias govaluerecommender='cd $CEDAR_HOME/cedar-valuerecommender-server'
alias gosubmission='cd $CEDAR_HOME/cedar-submission-server'
alias goworker='cd $CEDAR_HOME/cedar-worker-server'

alias goeventlistener='cd $CEDAR_HOME/cedar-keycloak-event-listener'

alias goeditor='cd $CEDAR_HOME/cedar-template-editor'

alias gokk='cd $KEYCLOAK_HOME/bin'

#CEDAR Git util aliases
alias cedargstatus='$CEDAR_UTIL_BIN/git/gitstatus.sh'
alias cedargbranches='$CEDAR_UTIL_BIN/git/gitbranches.sh'
alias cedargpull='$CEDAR_UTIL_BIN/git/gitpull.sh'
alias cedargcheckout='$CEDAR_UTIL_BIN/git/git-checkout-branch.sh'
alias cedarenv='set | grep -a CEDAR_'
alias cedarat='$CEDAR_HOME/cedar-admin-tool/dist/cedar-admin-tool.sh'

#Maven aliases
alias mi='mvn -T 2C install'
alias mcl='mvn -T 2C clean'
alias mci='mvn -T 2C clean install'
alias mit='mvn -T 2C install -DskipTests=true'
alias mcit='mvn -T 2C clean install -DskipTests=true'

#Maven and shell aliases
alias m2clean='rm -rf ~/.m2/repository/*'
alias m2cleancedar='rm -rf ~/.m2/repository/org/metadatacenter/*'

#3rd party server aliases
alias startnginx='$CEDAR_UTIL_BIN/services/startnginx.sh'
alias stopnginx='$CEDAR_UTIL_BIN/services/stopnginx.sh'

alias startkk='$CEDAR_UTIL_BIN/services/startkeycloak.sh'
alias killkk='$CEDAR_UTIL_BIN/services/killkeycloak.sh'

alias startmongo='$CEDAR_UTIL_BIN/services/startmongo.sh'
alias stopmongo='$CEDAR_UTIL_BIN/services/stopmongo.sh'

alias startmysql='$CEDAR_UTIL_BIN/services/startmysql.sh'
alias stopmysql='$CEDAR_UTIL_BIN/services/stopmysql.sh'

alias startkibana='$CEDAR_UTIL_BIN/services/startkibana.sh'
alias stopkibana='$CEDAR_UTIL_BIN/services/stopkibana.sh'

alias startelastic='$CEDAR_UTIL_BIN/services/startelastic.sh'
alias stopelastic='$CEDAR_UTIL_BIN/services/stopelastic.sh'

alias startneo='$CEDAR_UTIL_BIN/services/startneo.sh'
alias stopneo='$CEDAR_UTIL_BIN/services/stopneo.sh'

alias startredis='$CEDAR_UTIL_BIN/services/startredis.sh'
alias stopredis='$CEDAR_UTIL_BIN/services/stopredis.sh'

alias startrc='$CEDAR_UTIL_BIN/services/startrediscommander.sh'
alias killrc='$CEDAR_UTIL_BIN/services/killrediscommander.sh'

#CEDAR server aliases
alias starteditor='goeditor && gulp &'
alias stopeditor='kill `pgrep gulp`'

alias startworkspace='$CEDAR_UTIL_BIN/services/start-dw-server.sh workspace &'
alias stopworkspace='$CEDAR_UTIL_BIN/services/stop-dw-server.sh workspace 9208'
alias startmessaging='$CEDAR_UTIL_BIN/services/start-dw-server.sh messaging &'
alias stopmessaging='$CEDAR_UTIL_BIN/services/stop-dw-server.sh messaging 9212'
alias startgroup='$CEDAR_UTIL_BIN/services/start-dw-server.sh group &'
alias stopgroup='$CEDAR_UTIL_BIN/services/stop-dw-server.sh group 9209'
alias startrepo='$CEDAR_UTIL_BIN/services/start-dw-server.sh repo &'
alias stoprepo='$CEDAR_UTIL_BIN/services/stop-dw-server.sh repo 9202'
alias startresource='$CEDAR_UTIL_BIN/services/start-dw-server.sh resource &'
alias stopresource='$CEDAR_UTIL_BIN/services/stop-dw-server.sh resource 9207'
alias startschema='$CEDAR_UTIL_BIN/services/start-dw-server.sh schema &'
alias stopschema='$CEDAR_UTIL_BIN/services/stop-dw-server.sh schema 9203'
alias starttemplate='$CEDAR_UTIL_BIN/services/start-dw-server.sh template &'
alias stoptemplate='$CEDAR_UTIL_BIN/services/stop-dw-server.sh template 9201'
alias startterminology='$CEDAR_UTIL_BIN/services/start-dw-server.sh terminology &'
alias stopterminology='$CEDAR_UTIL_BIN/services/stop-dw-server.sh terminology 9204'
alias startuser='$CEDAR_UTIL_BIN/services/start-dw-server.sh user &'
alias stopuser='$CEDAR_UTIL_BIN/services/stop-dw-server.sh user 9205'
alias startvaluerecommender='$CEDAR_UTIL_BIN/services/start-dw-server.sh valuerecommender &'
alias stopvaluerecommender='$CEDAR_UTIL_BIN/services/stop-dw-server.sh valuerecommender 9206'
alias startsubmission='$CEDAR_UTIL_BIN/services/start-dw-server.sh submission &'
alias stopsubmission='$CEDAR_UTIL_BIN/services/stop-dw-server.sh submission 9210'
alias startworker='$CEDAR_UTIL_BIN/services/start-dw-server.sh worker &'
alias stopworker='$CEDAR_UTIL_BIN/services/stop-dw-server.sh worker 9211'

alias stopall='$CEDAR_UTIL_BIN/services/stopall.sh'
alias startall='$CEDAR_UTIL_BIN/services/startall.sh'

alias startinfra='$CEDAR_UTIL_BIN/services/startinfra.sh'
alias stopinfra='$CEDAR_UTIL_BIN/services/stopinfra.sh'

alias ij="'/Applications/IntelliJ IDEA.app/Contents/MacOS/idea'"

alias rmmvn='rm -rf ~/.m2/repository/'