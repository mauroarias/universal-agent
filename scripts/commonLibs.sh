#!/bin/bash

source ./scripts/configFile.sh

function reloadOsVar {
	eval $(cat $profileFile | grep "export $1=") 
}

#printAlert <message to print> 
function printAlert {
	printTitleWithColor "$1" "$RED"
}

#printAlert <message to print> <color> 
function printTitleWithColor {
    msg=$1
    color=$2
	echo "$color*******************************"
	echo "$msg"
	echo "*******************************$RESET"
}

#printMessage <message to print> 
function printMessage {
    msg=$1
	echo "$AGUA$msg$RESET"
}

#printMessageWithColor <message to print> <color> 
function printMessageWithColor {
    msg=$1
    color=$2
	echo "$color$msg$RESET"
}

function error {
	exit 1
}

function exitOnError {
    msg=$1
	printAlert "$msg"
	error
}

function generateRandom {
	size=$1
	cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c $size
}

function getVersion {
    cat ./version
}

function traceOff {
    set +e
}

function traceOn {
    set -e
}

function printHelp {
    echo "add help here...!"
}

function validateVarDefined {
    var=$1
    varName=$2
    echo "$var"
    if [ -z "$var" ]
    then
        exitOnError "$varName must be defined...!"
    fi
}

function loadingArguments {
    while [[ $# -gt 0 ]]
    do
        case $1 in
            -c|--cmd)
                command=$2
                shift
                ;;
            -r|--remote)
                remote=$2
                shift
                ;;
            -u|--user)
                user=$2
                shift
                ;;
            -p|--password)
                password=$2
                shift
                ;;
            -t|--template)
                template=$2
                shift
                ;;
            -s|--service)
                serviceName=$2
                shift
                ;;
            -j|--project)
                projectName=$2
                shift
                ;;
            -b|--cloneFromBranch)
                branche=$2
                shift
                ;;
            -h|--help|*)
                help
                exit
                ;;
        esac
        shift
    done
}

function loadGitHandler {
    if [ "$remote" == "gitHub" ]
    then
        source ./scripts/git/gitHubLib.sh
    elif [ "$remote" == "bitBucket" ]
    then
        source ./scripts/git/bitBucketLib.sh
    else
        exitOnError "remote must be defined...!"
    fi
}

function cloneRepoWithBranch {
    validateVarDefined "$template" "template"
    validateVarDefined "$serviceName" "service name"
    validateVarDefined "$branche" "template repository branch name"
    rm -rf $WORK_DIR/$serviceName
    git clone -b $branche $GIT_REPO_TEMPLATE/$template $WORK_DIR/$serviceName
}

function initRepo {
    git config --global user.email \"$GIT_JENKINS_EMAIL\"
    git config --global user.name \"$GIT_JENKINS_NAME\"
    rm -rf .git
    git init
    echo "adding remote in $remote"
    addRemote
}

function commitAndPushRepo {
    git add -A
    git commit -m 'firts draft from template'
    git branch -M "$GIT_BRANCH"
    git push -u origin "$GIT_BRANCH"
}
