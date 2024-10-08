#!/bin/sh
# Uncomment for debugging
#set -x
pingf(){
    if ping -w 2 -q -c 1 10.254.11."$1" > /dev/null ;
    then 
        printf "IP %s is up\n" 10.254.11."$1"
    fi
}

main(){

    NUM=1
    while [ $NUM -lt 255  ];do 
        pingf "$NUM" &
        NUM=$(expr "$NUM" + 1)
    done
    wait
}

main
