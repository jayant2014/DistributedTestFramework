#!/bin/sh

function test_log() {
    echo -e "$1" | tee -a $LOGFILE    
}

function test_out(){
    echo -e "$1" | tee -a $LOGFILE $OUTFILE
}

function report() {
    echo -e "Reporting"
}
