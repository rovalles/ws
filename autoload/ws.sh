#!/bin/sh

FOLDER=""

function changeDirectory(){
    local newFolder=$1
    local default=$2
    if [[ -n "$newFolder" && "$newFolder" != "$default" ]] ; then
        cd "$newFolder"
    else
        cd "$WS_DIR"
    fi
}

function listFolders(){
    local list=$(ls $WS_DIR)
    COMPREPLY=()

    COMPREPLY=( $( compgen -W "$list" -- $1 ) )
    FOLDER=$WS_DIR$COMPREPLY
}

function _complete(){
    local list=""

    CUR=${COMP_WORDS[COMP_CWORD]}
    PREV=${COMP_WORDS[COMP_CWORD-1]}

    if [[ -n "$PREV" ]] ; then
        case "$PREV" in
            *)
                listFolders "$CUR"
            ;;
        esac
    fi
}

function ws(){
    changeDirectory "$FOLDER" "$WS_DIR"
}

if [[ -n "$WS_DIR" ]] ; then
  complete -F _complete ws
else
  echo "Set your absolute project path to WS_DIR"
fi
