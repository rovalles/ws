#!/bin/sh
DIR=~/Git-Workspace/

FOLDER=""
GRUNT=""
PULL=""
COMPREPLY=()

function changeDirectory(){
    local newFolder=$1
    local default=$2
    if [[ -n "$newFolder" && "$newFolder" != "$default" ]] ; then
        cd "$newFolder" 
    else
        cd "$default"
    fi
}

function listFolders(){
    local list=$(ls $DIR)

    COMPREPLY=( $( compgen -W "$list" -- $1 ) )
    FOLDER=$DIR$COMPREPLY
}

function getBranches(){
    if [ -n $FOLDER ] ; then
        local list=$(git -C "$FOLDER" branch | cut -c 3-)

        COMPREPLY=( $( compgen -W "$list" -- $1 ) )
        BRANCH="$COMPREPLY"
    fi
}

function getHelp(){
    local list=( "-f --folder -b --branch -g --grunt")

    COMPREPLY=( $( compgen -W "$list" -- $1 ) )
}

function _complete(){
    local list=""

    CUR=${COMP_WORDS[COMP_CWORD]}
    PREV=${COMP_WORDS[COMP_CWORD-1]}

    if [ -n $PREV ] ; then
        case "$PREV" in
            -f | --folder)
                listFolders $CUR
            ;;
            -b | --branch)
                getBranches $CUR
            ;;
            -g | --grunt)
                GRUNT="$CUR"
            ;;
            -h | --help)
                getHelp $CUR
            ;;
            *) 
                listFolders $CUR
            ;;
        esac
    fi
}

function ws(){
    changeDirectory $FOLDER $DIR

    [ -n "$BRANCH" ] && git pull origin $BRANCH
    [ -n "$GRUNT" ] && grunt $GRUNT
}

complete -F _complete ws
