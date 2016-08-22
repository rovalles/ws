#!/bin/sh
[ -n $DIR ] && DIR=~/Git-Workspace/

FOLDER=""

function changeDirectory(){
    local newFolder=$1
    local default=$2
    if [[ -n "$newFolder" && "$newFolder" != "$default" ]] ; then
        cd "$newFolder"
    else
        cd "$DIR"
    fi
}

function listFolders(){
    local list=$(ls $DIR)
    COMPREPLY=()

    COMPREPLY=( $( compgen -W "$list" -- $1 ) )
    FOLDER=$DIR$COMPREPLY
}

function _complete(){
    local list=""

    CUR=${COMP_WORDS[COMP_CWORD]}
    PREV=${COMP_WORDS[COMP_CWORD-1]}

    if [[ -n $PREV ]] ; then
        case "$PREV" in
            *)
                listFolders $CUR
            ;;
        esac
    fi
}

function ws(){
    changeDirectory $FOLDER $DIR
}

complete -F _complete ws
