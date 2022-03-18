#!/bin/bash

source ./scripts/commonLibs.sh

version=$(getVersion)
printMessage "Using version $version"

pwd=$(pwd)

loadingArguments $@
loadGitHandler

case $command in
    gettingRepository)
        echo "getting repository"
        createProjectIfNotExitsIfAppl
        isRepositoryExits
        if [ "$isExits" == true ]
        then
            exitOnError "repository already exists...!"
        fi
        ;;
    applyTemplate)
        cloneRepoWithBranch
        echo $serviceName
        cd $WORK_DIR/$serviceName
        prepare.sh $serviceName
        rm prepare.sh
        createRepo
        initRepo
        commitAndPushRepo
        cd $pwd
        ;;
    *)
        exitOnError "missing comand action...!"
        ;;
esac