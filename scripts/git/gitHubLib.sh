#!/bin/bash

if [ -z "$user" ]
then
    exitOnError 'user must be defined...!'
fi
if [ -z "$password" ]
then
    exitOnError 'token must be defined...!'
fi

path="https://${user}:${password}@github.com/${user}/"
apiUri='https://api.github.com/user/repos'


function createProjectIfNotExitsIfAppl {
    echo 'ignoring project abstraction, it is not supported in github'
}

function isRepositoryExits {
    validateVarDefined "$projectName" 'project name'
    echo "curl -sLI -w '%{http_code}' -H 'Accept: application/vnd.github.v3+json' $path$projectName -o /dev/null"
    status=$(curl -sLI -w '%{http_code}' -H 'Accept: application/vnd.github.v3+json' $path$projectName -o /dev/null)
    echo "repository status code was $status"
    if [ $status -eq 200 ]
    then
        isExits=true
    else
        isExits=false
    fi
}

function createRepo {
    validateVarDefined "$serviceName" "service name"
    curl -H "Authorization: token $password" --data "{\"name\":\"$serviceName\"}" $apiUri
}

function addRemote {
    validateVarDefined "$serviceName" "service name"
    git remote add origin $path$serviceName.git
}

function getRepos {
    repos=$(curl -H "Authorization: token $password" -X GET $apiUri | jq -r '.[] | .name')
    echo $repos
}

function getPathRepo {
    validateVarDefined "$serviceName" "service name"
    echo "https://github.com/$user/$serviceName"
}

function getRepoOwner {
    echo "$user"
}
