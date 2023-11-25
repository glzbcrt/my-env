#!/bin/bash

pinfo() {
    if [ "$1" != "" ] && [ -d /proc/$1 ]; then
        echo -e "\n- process \033[33m$1 \033[32menvironment variables:\n\033[37m"
        cat /proc/$1/environ | tr '\0' '\n'
        
        echo -e "\n- process \033[33m$1 \033[32mcommand line:\n\033[37m"
        cat /proc/$1/cmdline | tr '\0' '\n'
    else
        echo -e "\npinfo needs a running process id. eg: pinfo 342\n"
    fi
}

cinfo() {
    if [ "$1" != "" ]; then
        netstat -atulpn | grep $1
    else
        echo -e "\ncinfo needs a connection filter, like a port number. eg: cinfo 80\n"
    fi
}
