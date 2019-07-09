#!/bin/bash

_WS_FOLDER=""
_WS_CURRENT_INDEX=0
_WS_PROJECT_LIST=(`echo ${WS_DIR}`)
_WS_CURRENT_DIR=${_WS_PROJECT_LIST[$_WS_CURRENT_INDEX]}

function _ws_change_directory(){
    cd "$1"
    _WS_FOLDER=""
}

function _ws_display(){
    local dumb="- - - - - W o r k s p a c e s - - - - -"
    t=$1

    dumb=(`echo ${dumb}`)
    for d in "${dumb[@]}"
    do
        sleep $t
        echo -n  "$d"
    done

    echo ""
    echo ""
}

function _ws_help(){
    local count=0
    local _g="\e[32m"
    local _w="\e[97m"

    _ws_display 0


    for each in "${_WS_PROJECT_LIST[@]}"
    do
        echo  "[$count] $each"
        count=$(($count+1))
    done
    echo ""
}

function _ws_search(){
    local list

    list=$(ls $_WS_CURRENT_DIR)
    list+=" -h --help "
    COMPREPLY=( $( compgen -W "$list" -- "$1" ) )

    if [[ -n "$1" ]] ; then
      _WS_FOLDER="$_WS_CURRENT_DIR$COMPREPLY"
    fi
}

function _ws_complete(){
    _WS_PROJECT_LIST=(`echo ${WS_DIR}`)
    local CUR=${COMP_WORDS[COMP_CWORD]}
    local PREV=${COMP_WORDS[COMP_CWORD-1]}

    case "$PREV" in
        [0-9])
            _WS_CURRENT_INDEX="$PREV"
            _WS_CURRENT_DIR=${_WS_PROJECT_LIST[$PREV]}
            _ws_search "$CUR"
        ;;
        *)
            _WS_CURRENT_DIR=${_WS_PROJECT_LIST[$_WS_CURRENT_INDEX]}
            _ws_search "$CUR"
        ;;
    esac
}

function _ws_submit(){
    local submit="$1"

    if [[ "$submit" == "-h" || "$submit" == "--help" ]] ; then
        _ws_help
    else
        _ws_change_directory "$_WS_FOLDER"
    fi
}

function ws(){
    _ws_submit "$1"
}

if [[ -n "$WS_DIR" ]] ; then
  complete -F _ws_complete ws
else
  echo "Set WS_DIR to your absolute project path in your ~/.bashrc"
fi
